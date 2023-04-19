"""Teamcenter monitoring agent

This lambda function runs every minute to check the status of Teamcenter
processes. The status is then published as custom metrics in AWS CloudWatch.
"""

import boto3
import os
import json
import socket
import ssl
import urllib
import xml.etree.ElementTree as ET
from urllib.parse import urlparse
from urllib.request import urlopen

region = ''
namespace = 'Engcloud/Teamcenter'


def detect_running_region():
    """Dynamically determine the region"""
    easy_checks = [
        # check if set through ENV vars
        os.environ.get('AWS_REGION'),
        os.environ.get('AWS_DEFAULT_REGION'),
        # else check if set in config or in boto already
        boto3.DEFAULT_SESSION.region_name if boto3.DEFAULT_SESSION else None,
        boto3.Session().region_name,
    ]
    for region in easy_checks:
        if region:
            return region

    # else query an external service
    # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-identity-documents.html
    url = 'http://169.254.169.254/latest/dynamic/instance-identity/document'
    instance_identity = json.loads(urlopen(url).read())
    return instance_identity['region']


def get_env_xml_codecommit(clone_url, env_name):
    global region
    region = detect_running_region()
    print('Running in region %s' % region)
    cc = boto3.client('codecommit', region_name=region)
    try:
        repo = clone_url.split('/')[-1]
        f = ('environments/teamcenter/%s'
             '/quick_deploy_configuration.xml' % env_name)
        print('Downloading file %s from codecommit repo %s' % (f, repo))
        resp = cc.get_file(
            repositoryName=repo,
            filePath=f
        )
        print('Got quick deploy file')
        xml = resp['fileContent'].decode('utf-8')
        return xml, None

    except Exception as e:
        print("Got error downloading or processing xml file: %s" % e)
        return None, {
            'statusCode': 500,
            'body': str(e)
        }


def get_env_xml(repo_type, clone_url, env_name):
    if repo_type == 'codecommit':
        return get_env_xml_codecommit(clone_url, env_name)
    else:
        None, {
            'statusCode': 400,
            'body': 'Unussported gitrepository type %s' % repo_type
        }


def get_instance_id(url):
    try:
        domain = url.split('/')[2]
        if ':' in domain:
            domain = domain.split(':')[0]
        ip = socket.gethostbyname(domain)
        ec2 = boto3.client('ec2')
        filters = [{
            'Name': 'private-ip-address',
            'Values': [ip],
        }]
        res = ec2.describe_instances(Filters=filters)
        if 'Reservations' not in res:
            print('Reservations not in response')
            return 'N/A'
        reserv = res['Reservations']
        if len(reserv) < 1:
            print('Reservations empty')
            return 'N/A'
        if 'Instances' not in reserv[0]:
            print('Instances not in reservations')
            return 'N/A'
        instances = reserv[0]['Instances']
        if len(instances) < 1:
            print('No instances')
            return 'N/A'
        return instances[0]['InstanceId']
    except Exception as e:
        print('Error determining instance_id of url %s:\n%s' % (url, e))
        return 'N/A'


def check_url(url, codes):
    try:
        socket.setdefaulttimeout(3.0)
        if url.startswith('https'):
            # dns = urlparse(url).hostname
            # print('Add self signed cert for host %s' % dns)
            # cert = ssl.get_server_certificate((dns, 443))
            # open('/tmp/mycert.crt', 'w').write(cert)
            # myssl = ssl.create_default_context()
            # myssl.load_verify_locations('/tmp/mycert.crt')
            # TODO: Check right certificate
            myssl = ssl._create_unverified_context()
            resp = urlopen(url, timeout=3.0, context=myssl)
        else:
            resp = urlopen(url, timeout=3.0)
        print('Response: %s' % resp.status)
        return resp.status in codes
    except urllib.error.HTTPError as e:
        print('Response: %s' % e.code)
        return e.code in codes
    except Exception as e:
        print('Error making a request to %s:\n%s' % (url, e))
        return False


def post_cw_metric(metric, is_up, url, env_name, include_instance_id):
    parts = url.split('/')
    if len(parts) > 1:
        hostname = url.split('/')[2]
    else:
        hostname = url
    if ':' in hostname:
        hostname = hostname.split(':')[0]
    dim = [
        {
            'Name': 'Environment',
            'Value': env_name,
        },
        {
            'Name': 'Hostname',
            'Value': hostname,
        }
    ]
    cw = boto3.client('cloudwatch', region_name=region)
    value = 0
    if is_up:
        value = 1
    print('Posting CloudWatch metric %s with dimensions %s' % (metric, dim))
    resp = cw.put_metric_data(
        MetricData=[
            {
                'MetricName': metric,
                'Unit': 'Count',
                'Value': value,
                'Dimensions': dim,
            },
        ],
        Namespace=namespace
    )
    print('Posted metric with status code %s' %
          resp['ResponseMetadata']['HTTPStatusCode'])
    if not include_instance_id:
        return
    instance_id = get_instance_id(url)
    dim = dim + [
        {
            'Name': 'InstanceId',
            'Value': instance_id,
        }
    ]
    print('Posting CloudWatch metric %s with dimensions %s' % (metric, dim))
    resp = cw.put_metric_data(
        MetricData=[
            {
                'MetricName': metric,
                'Unit': 'Count',
                'Value': value,
                'Dimensions': dim,
            },
        ],
        Namespace=namespace
    )
    print('Posted metric with status code %s' %
          resp['ResponseMetadata']['HTTPStatusCode'])


def check_fsc(comp, env_name):
    for prop in comp:
        if 'id' not in prop.attrib:
            continue
        if prop.attrib['id'] != 'fnd0_fscURL':
            continue
        url = prop.attrib['value']
        print('==> Checking FSC at %s' % url)
        is_up = check_url(url, [200, 400])
        print('Is up: %s' % is_up)
        post_cw_metric('fsc-up', is_up, url, env_name, True)
        return


def check_poolmgr(comp, env_name):
    domain = comp.attrib['machineName']
    for prop in comp:
        if 'id' not in prop.attrib:
            continue
        if prop.attrib['id'] != 'fnd0_assignmentServicePort':
            continue
        port = prop.attrib['value']
        url = 'http://%s:%s' % (domain, port)
        print('==> Checking pool manager at %s' % url)
        is_up = check_url(url, [200, 404, 405])
        print('Is up: %s' % is_up)
        post_cw_metric('poolmgr-up', is_up, url, env_name, True)
        return


def check_licserver(comp, env_name):
    domain = comp.attrib['machineName']
    for prop in comp:
        if 'id' not in prop.attrib:
            continue
        if prop.attrib['id'] != 'fnd0_tcLincensingPort':
            continue
        port = prop.attrib['value']
        is_up = False
        url = 'http://%s:%s' % (domain, port)
        try:
            print('==> Checking license server at %s' % url)
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                s.connect((domain, int(port)))
                is_up = True
        except Exception as e:
            print('Error connecting to lic server at %s:\n%s' % (url, e))
        print('Is up: %s' % is_up)
        post_cw_metric('licserver-up', is_up, url, env_name, False)
        return


def check_ms(comp, env_name):
    for prop in comp:
        if 'id' not in prop.attrib:
            continue
        if prop.attrib['id'] != 'fnd0_microservice_url':
            continue
        url = prop.attrib['value']
        print('==> Checking service dispatcher at %s' % url)
        is_up = check_url(url, [404])
        print('Is up: %s' % is_up)
        post_cw_metric('ms/sd-up', is_up, url, env_name, False)
        base_url = prop.attrib['value']
        if not base_url.endswith('/'):
            base_url = base_url + '/'
        url = '%sfilerepo' % prop.attrib['value']
        print('==> Checking filerepo microservice at %s' % url)
        is_up = check_url(url, [401])
        print('Is up: %s' % is_up)
        post_cw_metric('ms/filerepo-up', is_up, url, env_name, False)
        url = '%safx-darsi' % prop.attrib['value']
        print('==> Checking afx-darsi microservice at %s' % url)
        is_up = check_url(url, [200])
        print('Is up: %s' % is_up)
        post_cw_metric('ms/afx-darsi-up', is_up, url, env_name, False)
        url = '%stcgql' % prop.attrib['value']
        print('==> Checking tcgql microservice at %s' % url)
        is_up = check_url(url, [200])
        print('Is up: %s' % is_up)
        post_cw_metric('ms/tcgql-up', is_up, url, env_name, False)
        return


def check_awg(root, comp, env_name):
    for prop in comp:
        if 'id' not in prop.attrib:
            continue
        if prop.attrib['id'] != 'aws2_client_gateway_webtier_url':
            continue
        url = prop.attrib['value']
        for c in root.findall("quickDeployComponents/component"):
            id = c.attrib["id"]
            if id == 'aws2_client_builder':
                for p in c:
                    if 'component' not in p.attrib:
                        continue
                    if p.attrib['component'] != 'aws2_client_gateway_webtier':
                        continue
                    for cp in p:
                        if 'id' not in cp.attrib:
                            continue
                        if cp.attrib['id'] != \
                                'aws2_client_gateway_webtier_url':
                            continue
                        url = cp.attrib['value']
        print('==> Checking Active Workspace Gateway at %s' % url)
        is_up = check_url(url, [200])
        print('Is up: %s' % is_up)
        post_cw_metric('awg-up', is_up, url, env_name, False)
        return


def check_web(comp, env_name):
    for prop in comp:
        if 'id' not in prop.attrib:
            continue
        if prop.attrib['id'] != 'fnd0_j2ee_4tierURI':
            continue
        url = prop.attrib['value']
        url = url + '/controller/test'
        print('==> Checking web tier at %s' % url)
        is_up = check_url(url, [200])
        print('Is up: %s' % is_up)
        post_cw_metric('web-up', is_up, url, env_name, False)
        return


def check_db(comp, env_name):
    hostname = comp.attrib['machineName']
    for prop in comp:
        if 'id' not in prop.attrib:
            continue
        if prop.attrib['id'] != 'fnd0_oracleDBPort':
            continue
        port = prop.attrib['value']
        is_up = False
        url = '%s:%s' % (hostname, port)
        try:
            print('==> Checking db server at %s' % url)
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                s.connect((hostname, int(port)))
                is_up = True
        except Exception as e:
            print('Error connecting to databse server at %s:\n%s' % (url, e))
        print('Is up: %s' % is_up)
        post_cw_metric('db-up', is_up, url, env_name, False)
        return


def check_indexing(comp, env_name):
    for prop in comp:
        if 'id' not in prop.attrib:
            continue
        if prop.attrib['id'] != 'aws2_indexingEngineURL':
            continue
        url = prop.attrib['value']
        if not url.endswith('/'):
            url = url + '/'
        print('==> Checking indexing engine at %s' % url)
        is_up = check_url(url, [401])
        print('Is up: %s' % is_up)
        post_cw_metric('idx-up', is_up, url, env_name, False)
        return


def check_targets(xml, env_name):
    root = ET.fromstring(xml)
    for c in root.findall("quickDeployComponents/component"):
        id = c.attrib["id"]
        if id == 'fnd0_fsc':
            check_fsc(c, env_name)
        elif id == 'fnd0_serverManager':
            check_poolmgr(c, env_name)
        elif id == 'fnd0_licensingserver':
            check_licserver(c, env_name)
        elif id == 'fnd0_microservice':
            check_ms(c, env_name)
        elif id == 'aws2_client_gateway_webtier':
            check_awg(root, c, env_name)
        elif id == 'fnd0_j2ee_tcwebtier':
            check_web(c, env_name)
        elif id == 'fnd0_tcdbserver':
            check_db(c, env_name)
        elif id == 'aws2_indexingengine':
            check_indexing(c, env_name)


def lambda_handler(event, context):
    print('Processing event:\n%s' % (event))
    xml, resp = get_env_xml(event['repo_type'], event['clone_url'],
                            event['env_name'])
    if resp:
        return resp
    check_targets(xml, event['env_name'])
    return {
        'statusCode': 200,
        'body': 'Health checker finished successfully'
    }
