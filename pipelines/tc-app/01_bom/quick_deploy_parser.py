"""Parser for teamcenter quick deploy configuration xml.

This script runs as a lambda function. It scans a teamcenter "quick deploy"
environment xml file and transforms the information to a format suitable
to be used in CI/CD pipelines.

Environment Variables:

    INPUT_SOURCE: One of "base64", "s3" or "code_pipeline", or "github"

        - base64        Input file is included in the field "quick_deploy"
                        in the input payload.
        - s3            Input file is located in a S3 bucket.
        - code_pipeline Input file comes from an input artifact of a
                        CodePipeline pipeline.
        - github        Input file is downloaded from github using a
                        Personal Access Token (PAT), read from Secrets Manager
                        secret /teamcenter/github-api-token

    OUTPUT_DESTINATION: One of "ssm" or "s3"

        - ssm     Parsed content is stored as parameters of SSM
                  Parameter Store.
        - s3      Parsed content is stored in a JSON file in a S3 bucket.

    REGION: Region were S3 or SSM are located for input/output.

Inputs:
    base64 input:
        - quick_deploy  Field having the xml file in base64 encoded format.
        - s3_out_uri    If output is s3, this is the URI in "s3://" format
                        indicating the full path to the output file in S3.
        - ssm_prefix    If output is ssm, this is the prefix to use for all
                        parameters.
    s3 input:
        - s3_in_uri     URI in "s3://" format indicating the full path
                        to the file.
        - s3_out_uri    If output is s3, this is the URI in "s3://" format
                        indicating the full path to the output file in S3.
        - ssm_prefix    If output is ssm, this is the prefix to use for all
                        parameters.
    code_pipeline input:
        - file_path     Path inside the source zip file were the xml file
                        is located, provided as a user parameter in
                        CodePipeline.
        - s3_out_uri    If output is s3, this is the URI in "s3://" format
                        indicating the full path to the output file in S3.
        - ssm_prefix    If output is ssm, this is the prefix to use for all
                        parameters.
    github input:
        - github_prefix_url Github API url prefix. Defaults to
                            https://api.github.com
        - org               Github organization.
        - repo              Github repository.
        - file_path         Path to the quick deploy file relative to the repo
                            root.
        - s3_out_uri        If output is s3, this is the URI in "s3://" format
                            indicating the full path to the output file in S3.
        - ssm_prefix        If output is ssm, this is the prefix to use for all
                            parameters.

"""
import collections.abc
import base64
import boto3
import json
import os
import tempfile
import urllib.request
import xml.etree.ElementTree as ET
import zipfile

from pprint import pprint
from urllib.parse import urlparse

# These components are not considered enterprise tier servers
not_enterprise_servers = [
    'fnd0_tcdbserver',
    'fnd0_microservice',
    'fnd0_j2ee_tcwebtier',
    'fnd0_licensingserver',
    'fnd0_serverpool_DBConfig',
    'aws2_indexingengine',
    'aws2_client_builder',
    'aws2_client_gateway_webtier',
]


def extract_env(result, root):
    result['env_name'] = root.attrib['configName']
    return result, None


def extract_arch(result, root):
    for a in root.findall('archType'):
        result['arch'] = a.attrib['types']
        return result, None


def extract_software(result, root):
    result['software_versions'] = {}
    for s in root.findall('quickDeploySoftware/software'):
        id = s.attrib['id']
        version = s.attrib['version']
        result['software_versions'][id] = version
    return result, None


def extract_aw_gateway(result, root):
    result['aw_gateway'] = {}
    for c in root.findall('quickDeployComponents/component'):
        id = c.attrib['id']
        machine_name = c.attrib['machineName']
        platform = c.attrib['platform']
        if not id == 'aws2_client_gateway_webtier':
            continue
        result['aw_gateway']['hostname'] = machine_name
        result['aw_gateway']['platform'] = platform
        for p in c.findall('property'):
            p_id = p.attrib['id']
            p_value = p.attrib['value']
            if p_id == 'aws2_client_gateway_webtier_installationPath':
                result['aw_gateway']['install_path'] = p_value
            elif p_id == 'aws2_client_gateway_webtier_url':
                result['aw_gateway']['urls'] = p_value
                dns = urlparse(p_value).hostname
                result['aw_gateway']['dns'] = dns
            elif p_id == 'aws2_client_gateway_webtier_gatewayPort':
                result['aw_gateway']['port'] = p_value
    for c in root.findall('quickDeployComponents/component'):
        id = c.attrib['id']
        if not id == 'aws2_client_builder':
            continue
        for conn in c.findall('connectedTo'):
            comp_id = conn.attrib['component']
            if comp_id == 'aws2_client_gateway_webtier':
                for p in conn.findall('property'):
                    p_id = p.attrib['id']
                    p_value = p.attrib['value']
                    if p_id == 'aws2_client_gateway_webtier_url':
                        result['aw_gateway']['urls'] += ',%s' % p_value
                        dns = urlparse(p_value).hostname
                        result['aw_gateway']['dns'] = dns
    return result, None


def extract_db(result, root):
    result['db'] = {}
    for c in root.findall('quickDeployComponents/component'):
        id = c.attrib['id']
        machine_name = c.attrib['machineName']
        platform = c.attrib['platform']
        if not id == 'fnd0_tcdbserver':
            continue
        result['db']['hostname'] = machine_name
        result['db']['platform'] = platform
        for p in c.findall('property'):
            p_id = p.attrib['id']
            p_value = p.attrib['value']
            if p_id == 'fnd0_oracleDBPort':
                result['db']['port'] = p_value
            elif p_id == 'fnd0_oracleDBUser':
                result['db']['user'] = p_value
            elif p_id == 'fnd0_databaseServerOptions':
                result['db']['engine'] = p_value
            elif p_id == 'fnd0_oracleDBService':
                result['db']['oracle_sid'] = p_value
    return result, None


def extract_awc_builder(result, root):
    result['awc_builder'] = {}
    for c in root.findall('quickDeployComponents/component'):
        id = c.attrib['id']
        machine_name = c.attrib['machineName']
        platform = c.attrib['platform']
        if not id == 'aws2_client_builder':
            continue
        result['awc_builder']['hostname'] = machine_name
        result['awc_builder']['platform'] = platform
        for p in c.findall('property'):
            p_id = p.attrib['id']
            p_value = p.attrib['value']
            if p_id == 'aws2_clientBuilderInstallationPath':
                result['awc_builder']['install_path'] = p_value
    return result, None


def extract_indexing_engine(result, root):
    result['indexing_engine'] = {}
    for c in root.findall('quickDeployComponents/component'):
        id = c.attrib['id']
        machine_name = c.attrib['machineName']
        platform = c.attrib['platform']
        if not id == 'aws2_indexingengine':
            continue
        result['indexing_engine']['hostname'] = machine_name
        result['indexing_engine']['platform'] = platform
        for p in c.findall('property'):
            p_id = p.attrib['id']
            p_value = p.attrib['value']
            if p_id == 'aws2_indexingEngineUser':
                result['indexing_engine']['user'] = p_value
            elif p_id == 'aws2_indexingEngineURL':
                result['indexing_engine']['url'] = p_value
                dns = urlparse(p_value).hostname
                result['indexing_engine']['dns'] = dns
            elif p_id == 'aws2_tcIndexingEngineInstallationPath':
                result['indexing_engine']['install_path'] = p_value
            elif p_id == 'aws2_machineUser':
                result['indexing_engine']['machine_user'] = p_value
    return result, None


def extract_web(result, root):
    result['web_tier'] = {}
    for c in root.findall('quickDeployComponents/component'):
        id = c.attrib['id']
        machine_name = c.attrib['machineName']
        platform = c.attrib['platform']
        if not id == 'fnd0_j2ee_tcwebtier':
            continue
        result['web_tier']['hostname'] = machine_name
        result['web_tier']['platform'] = platform
        for p in c.findall('property'):
            p_id = p.attrib['id']
            p_value = p.attrib['value']
            if p_id == 'fnd0_j2ee_tcwebtierInstallationPath':
                result['web_tier']['install_path'] = p_value
            elif p_id == 'fnd0_j2ee_tcwebtier.protocol':
                result['web_tier']['protocol'] = p_value
            elif p_id == 'fnd0_j2ee_tcwebtier.port':
                result['web_tier']['port'] = p_value
            elif p_id == 'fnd0_j2ee_4tierURI':
                result['web_tier']['url'] = p_value
                dns = urlparse(p_value).hostname
                result['web_tier']['dns'] = dns
    return result, None


def extract_license_server(result, root):
    result['license_server'] = {}
    for c in root.findall('quickDeployComponents/component'):
        id = c.attrib['id']
        machine_name = c.attrib['machineName']
        platform = c.attrib['platform']
        if not id == 'fnd0_licensingserver':
            continue
        result['license_server']['hostname'] = machine_name
        result['license_server']['platform'] = platform
        for p in c.findall('property'):
            p_id = p.attrib['id']
            p_value = p.attrib['value']
            if p_id == 'fnd0_j2ee_tcwebtierInstallationPath':
                result['license_server']['install_path'] = p_value
            elif p_id == 'fnd0_tcLincensingPort':
                result['license_server']['port'] = p_value
    return result, None


def extract_microservices(result, root):
    result['microservices'] = {'master': {}, 'others': []}
    for c in root.findall('quickDeployComponents/component'):
        id = c.attrib['id']
        if not id == 'fnd0_microservice':
            continue
        info = {}
        info['hostname'] = c.attrib['machineName']
        info['platform'] = c.attrib['platform']
        is_master = False
        for p in c.findall('property'):
            p_id = p.attrib['id']
            p_value = p.attrib['value']
            if p_id == 'fnd0_msType' and p_value == 'master':
                is_master = True
            elif p_id == 'fnd0_microservice_protocol':
                info['protocol'] = p_value
            elif p_id == 'fnd0_containerRegistry':
                info['container_registry'] = p_value
            elif p_id == 'fnd0_microservice_url':
                info['url'] = p_value
            elif p_id == 'fnd0_containerManager':
                info['container_orchestration'] = p_value
            elif p_id == 'fnd0_microservice_InstallationPath':
                info['install_path'] = p_value
            elif p_id == 'fnd0_microservice_port':
                info['port'] = p_value
            elif p_id == 'fnd0_k8sNamespace':
                info['kubernetes_namespace'] = p_value
            elif p_id == 'fnd0_ms_file_repo_file_storage_path':
                info['filerepo_storage_path'] = p_value
        if is_master:
            result['microservices']['master'] = info
        else:
            result['microservices']['others'].append(info)
    return result, None


def extract_fsc(result, component):
    ent = result['enterprise_tier']
    info = {}
    info['hostname'] = component.attrib['machineName']
    info['platform'] = component.attrib['platform']
    is_master = False
    for p in component.findall('property'):
        p_id = p.attrib['id']
        p_value = p.attrib['value']
        if p_id == 'fnd0_isMaster' and p_value == 'true':
            is_master = True
        elif p_id == 'fnd0_fscServerID':
            info['server_id'] = p_value
        elif p_id == 'fnd0_fscURL':
            info['url'] = p_value
        elif p_id == 'fnd0_fscInstallationPath':
            info['install_path'] = p_value
        elif p_id == 'fnd0_fscServerProtocol':
            info['protocol'] = p_value
        elif p_id == 'fnd0_fsc_machineUser':
            info['machine_user'] = p_value
        elif p_id == 'fnd0_fscServerPort':
            info['port'] = p_value
    if is_master:
        ent['fsc']['master'] = info
    else:
        ent['fsc']['others'].append(info)
    ent['fsc']['all'].append(info['hostname'])
    ent['all'].append(info['hostname'])


def extract_server_mgr(result, component):
    srv_mgr = result['enterprise_tier']['server_manager']
    info = {}
    info['hostname'] = component.attrib['machineName']
    info['platform'] = component.attrib['platform']
    for p in component.findall('property'):
        p_id = p.attrib['id']
        p_value = p.attrib['value']
        if p_id == 'fnd0_serverManagerInstallationPath':
            info['install_path'] = p_value
        elif p_id == 'fnd0_serverPoolId':
            info['pool_id'] = p_value
        elif p_id == 'fnd0_assignmentServicePort':
            info['assignment_port'] = p_value
        elif p_id == 'fnd0_jmxAdaptorPort':
            info['jmx_port'] = p_value
        elif p_id == 'fnd0_TECSAdminPort':
            info['tecs_port'] = p_value
        elif p_id == 'fnd0_muxPort':
            info['mux_port'] = p_value
    srv_mgr[info['hostname']] = info
    srv_mgr['all'].append(info['hostname'])
    result['enterprise_tier']['all'].append(info['hostname'])


def extract_indexer(result, component):
    ent = result['enterprise_tier']
    info = {}
    info['hostname'] = component.attrib['machineName']
    info['platform'] = component.attrib['platform']
    for p in component.findall('property'):
        p_id = p.attrib['id']
        p_value = p.attrib['value']
        if p_id == 'aws2_indexerInstallationPath':
            info['install_path'] = p_value
    ent['indexer'].append(info)
    ent['all'].append(info['hostname'])


def extract_corporate(result, component):
    ent = result['enterprise_tier']
    info = {}
    info['hostname'] = component.attrib['machineName']
    info['platform'] = component.attrib['platform']
    for p in component.findall('property'):
        p_id = p.attrib['id']
        p_value = p.attrib['value']
        if p_id == 'fnd0_tcAdminUser':
            info['tcadmin_user'] = p_value
        elif p_id == 'fnd0_tcCorporateServerInstallationPath':
            info['install_path'] = p_value
        elif p_id == 'fnd0_tcDataPath':
            info['data_path'] = p_value
        elif p_id == 'fnd0_tcVolumeDirPath':
            info['volume_path'] = p_value
    ent['corporate'] = info
    ent['all'].append(info['hostname'])


def extract_enterprise(result, root):
    result['enterprise_tier'] = {
        'fsc': {'master': {}, 'others': [], 'all': []},
        'corporate': {},
        'server_manager': {'all': []},
        'indexer': [],
        'all': [],
    }
    for c in root.findall('quickDeployComponents/component'):
        id = c.attrib['id']
        if id in not_enterprise_servers:
            continue
        if id == 'fnd0_fsc':
            extract_fsc(result, c)
        elif id == 'fnd0_corporateserver':
            extract_corporate(result, c)
        elif id == 'fnd0_serverManager':
            extract_server_mgr(result, c)
        elif id == 'aws2_ftsIndexer':
            extract_indexer(result, c)
    all = result['enterprise_tier']['all']
    result['enterprise_tier']['all'] = list(dict.fromkeys(all))
    return result, None


def parse_xml(xml_string):
    """
    Converts the quick deploy XML file into a data model suitable for CI/CD.
    Returns: Result dictionary and error string (if any).
    """
    print('Processing xml:\n%s' % (xml_string))
    root = ET.fromstring(xml_string)
    result = {}
    result, err = extract_env(result, root)
    if err:
        return None, err
    result, err = extract_software(result, root)
    if err:
        return None, err
    result, err = extract_arch(result, root)
    if err:
        return None, err
    result, err = extract_db(result, root)
    if err:
        return None, err
    result, err = extract_web(result, root)
    if err:
        return None, err
    result, err = extract_enterprise(result, root)
    if err:
        return None, err
    result, err = extract_indexing_engine(result, root)
    if err:
        return None, err
    result, err = extract_license_server(result, root)
    if err:
        return None, err
    result, err = extract_awc_builder(result, root)
    if err:
        return None, err
    result, err = extract_aw_gateway(result, root)
    if err:
        return None, err
    result, err = extract_microservices(result, root)
    if err:
        return None, err
    return result, None


def notify_job_failed(job_id, error):
    codepipeline = boto3.client("codepipeline")
    response = codepipeline.put_job_failure_result(
        jobId=job_id,
        failureDetails={
            'type': 'JobFailed',
            'message': error
        }
    )
    print('Response of posting to codepipeline: %s' % response)


def notify_job_successful(job_id, result):
    codepipeline = boto3.client("codepipeline")
    response = codepipeline.put_job_success_result(
        jobId=job_id,
        outputVariables={
            'result': str(result)
        }
    )
    print('Response of posting to codepipeline: %s' % response)


def get_xml_s3(event, region):
    """
    Downloads the quick deploy XML file from the S3 location
    specified in the input event parameters.
    Returns two values: the XML string and an error string, if any.
    """
    s3 = boto3.client("s3")
    uri = event['s3_in_uri']
    if not uri.startswith('s3://'):
        return None, 'Malformed S3 uri: %s, it should start with "s3://"' % uri
    bucket = s3.Bucket(urlparse(uri).hostname, region)
    s3_path = urlparse(uri).path.lstrip('/')
    try:
        bucket = s3.Bucket(bucket, region)
        destf = ('%s%squick_deploy.xml' % (tempfile.gettempdir(), os.path.sep))
        print('Downloading to %s' % destf)
        bucket.download_file(s3_path, destf)
        print('Reading xml file %s' % destf)
        with open(destf) as f:
            xml = f.read()
            return xml, None
    except Exception as e:
        return None, 'Got error downloading or reading XML file: %s' % e


def get_xml_code_pipeline(event, region):
    """
    Downloads the .zip file from the bucket specified in
    CodePipeline input artifact, extracts the .zip and reads
    the quick deploy XML file from the location specified
    in the user params.
    Returns two values: the XML string and an error string, if any.
    """
    data = event["CodePipeline.job"]["data"]
    input_art = data["inputArtifacts"][0]
    action_config = data["actionConfiguration"]["configuration"]
    user_params = action_config["UserParameters"]
    bucket_name = input_art["location"]["s3Location"]["bucketName"]
    bucket_key = input_art["location"]["s3Location"]["objectKey"]
    params = user_params.split(',')
    file_path = None
    for p in params:
        if 'file_path' not in p:
            continue
        file_path = p.split('=')[1]
    if not file_path:
        return None, '"file_path" not found on user parameters'
    print('Downloading code from bucket %s and key %s' %
          (bucket_name, bucket_key))
    s3 = boto3.resource('s3')
    try:
        bucket = s3.Bucket(bucket_name)
        zipf = '%s%ssource_code.zip' % (tempfile.gettempdir(), os.sep)
        print('Downloading to %s' % zipf)
        bucket.download_file(bucket_key, zipf)
        codedir = ('%s%ssource_code' % (tempfile.gettempdir(), os.sep))
        print('Extracting zip file to %s' % codedir)
        with zipfile.ZipFile(zipf, 'r') as zip_ref:
            zip_ref.extractall(codedir)
        xml_file = ('%s%s%s' % (codedir, os.sep, file_path))
        print('Reading xml file %s' % xml_file)
        with open(xml_file) as f:
            xml = f.read()
            return xml, None
    except Exception as e:
        return None, 'Got error downloading or reading XML file: %s' % e


def get_xml_base64(event):
    """
    Reads the quick deploy XML file from the base64 encoded string
    coming in the event.
    Returns two values: the XML string and an error string, if any.
    """
    encoded = event['quick_deploy']
    xml = base64.b64decode(encoded).decode('utf-8')
    return xml, None


def get_xml_github(event, region):
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region
    )
    try:
        resp = client.get_secret_value(
            SecretId='/teamcenter/github-api-token'
        )
        token = resp['SecretString']
    except Exception as e:
        return None, 'Error reading github token from Secrets Manager: %s' % e
    try:
        if 'github_prefix_url' not in event:
            prefix_url = 'https://api.github.com'
        else:
            prefix_url = event['github_prefix_url']
        url = '%s/repos/%s/%s/contents/%s' % \
              (prefix_url, event['org'], event['repo'], event['file_path'])
        headers = {
            'Authorization': 'Bearer %s' % token,
            'Accept': 'application/vnd.github.v3.raw'
        }
        print('Downloading quick deploy from github at %s' % url)
        req = urllib.request.Request(url, headers=headers, method='GET')
        with urllib.request.urlopen(req) as resp:
            if resp.status != 200:
                return None, 'Error downloading quick deploy file from '
                '%s, response code: %s' % (url, resp.status)
            xml = resp.read().decode(
                  resp.headers.get_content_charset("utf-8"))
            return xml, None
    except Exception as e:
        return None, 'Error downloading quick deploy file from github: %s' % e


def handle_error(input_src, event, err):
    if input_src == 'code_pipeline':
        job_id = event["CodePipeline.job"]["id"]
        notify_job_failed(job_id, err)
    return {
        'statusCode': 500,
        'body': err
    }


def handle_success(input_src, event, result):
    if input_src == 'code_pipeline':
        job_id = event["CodePipeline.job"]["id"]
        notify_job_successful(job_id, result)
    return {
        'statusCode': 200,
        'body': result
    }


def save_s3(event, region, model):
    """
    Saves the model in the S3 bucket specified in the event as a JSON file.
    Returns an error string, if any.
    """
    s3 = boto3.client("s3")
    uri = event['s3_out_uri']
    if not uri.startswith('s3://'):
        return None, 'Malformed S3 uri: %s, it should start with "s3://"' % uri
    bucket = urlparse(uri).hostname
    key = urlparse(uri).path.lstrip('/')
    try:
        print('Trying to delete old file if exists')
        s3.delete_object(Bucket=bucket, Key=key, Region=region)
        waiter = s3.get_waiter('object_not_exists')
        print('Waiting for old file to be deleted from S3')
        waiter.wait(Bucket=bucket, Key=key,
                    WaiterConfig={'Delay': 5, 'MaxAttempts': 20})
    except Exception as e:
        err = "Error deleting old file: %s, ignoring" % e
    try:
        response = s3.put_object(
            Body=json.dumps(model,
                            indent=4,
                            sort_keys=True),
            Bucket=bucket,
            Key=key,
            ContentType='application/json')
        waiter = s3.get_waiter('object_exists')
        print('Response of uploading results to S3: %s' % response)
        print('Waiting for object available in S3')
        waiter.wait(Bucket=bucket, Key=key,
                    WaiterConfig={'Delay': 5, 'MaxAttempts': 20})
    except Exception as e:
        err = "Error uploading file: %s" % e
        return err


def save_ssm_instance(param_name, item, ssm, existing):
    if isinstance(item, str):
        try:
            if param_name in existing and existing[param_name] == item:
                print('Not overwriting parameter %s with the same value' %
                      param_name)
                return
            print('Saving parameter %s to ssm parameter store' % param_name)
            ssm.put_parameter(
                Name=param_name,
                Overwrite=True,
                Value=item,
                Type='String'
            )
        except Exception as e:
            return 'Error saving parameter: %s' % e
    elif isinstance(item, collections.abc.Sequence):
        for index, value in enumerate(item):
            if isinstance(value, str):
                err = save_ssm_instance(param_name, ','.join(item),
                                        ssm, existing)
                break
            else:
                new_name = '%s/%s' % (param_name, index)
                err = save_ssm_instance(new_name, value,
                                        ssm, existing)
                if err:
                    return err
    else:
        for key in item:
            new_name = '%s/%s' % (param_name, key)
            err = save_ssm_instance(new_name, item[key],
                                    ssm, existing)
            if err:
                return err
    return None


def get_existing_ssm_params(prefix, ssm):
    paginator = ssm.get_paginator('get_parameters_by_path')
    response_iterator = paginator.paginate(
        Path=prefix,
        Recursive=True,
    )
    existing = {}
    for page in response_iterator:
        for entry in page['Parameters']:
            existing[entry['Name']] = entry['Value']
    return existing


def save_ssm(event, model):
    ssm = boto3.client('ssm')
    if 'ssm_prefix' not in event:
        prefix = ''
    else:
        prefix = event['ssm_prefix']
    prefix += '/teamcenter/%s' % model['env_name']
    print('Getting parameters by prefix %s' % prefix)
    existing = get_existing_ssm_params(prefix, ssm)
    print('Existing parameters: %s' % existing)
    return save_ssm_instance(prefix, model, ssm, existing)


def lambda_handler(event, context):
    """Entry point of the function."""
    print('Processing input event')
    pprint(event)
    input_src = os.getenv('INPUT_SOURCE', 'base64')
    output_dst = os.getenv('OUTPUT_DESTINATION', 's3')
    region = os.getenv('REGION', 'us-east-1')
    print('INPUT_SOURCE: %s, OUTPUT_DESTINATION: %s, REGION: %s' %
          (input_src, output_dst, region))
    if input_src == 'base64':
        xml, err = get_xml_base64(event)
    elif input_src == 's3':
        xml, err = get_xml_s3(event, region)
    elif input_src == 'code_pipeline':
        xml, err = get_xml_code_pipeline(event, region)
    elif input_src == 'github':
        xml, err = get_xml_github(event, region)
    else:
        err = 'Unknown INPUT_SOURCE %s' % input_src
        return handle_error(input_src, event, err)
    if err:
        return handle_error(input_src, event, err)
    model, err = parse_xml(xml)
    if err:
        return handle_error(input_src, event, err)
    if output_dst == 's3':
        err = save_s3(event, region, model)
    elif output_dst == 'ssm':
        err = save_ssm(event, model)
    else:
        err = 'Unknown OUTPUT_DESTINATION %s' % output_dst
        return handle_error(input_src, event, err)
    if err:
        return handle_error(input_src, event, err)
    return handle_success(input_src, event, model)


if __name__ == "__main__":
    event = {
        'org': 'DigitalOnUs',
        'repo': 'techm-engineering-cloud',
        'file_path': '.github/workflows/test_envs/german/teamcenter/env-kube/quick_deploy_configuration.xml',
    }
    pprint(lambda_handler(event, None))
