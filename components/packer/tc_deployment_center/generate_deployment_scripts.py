"""Generate TeamCenter deployment scripts

Inputs:
- TeamCenter environment XML file path
- Comma separated string of secret names
  Example: field1=secret_name,field2=secret_name

Output: Deployment scripts generated in default directory
"""
import boto3
import os
import random
import string
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
from urllib import parse

java_home = '/usr/lib/jvm/java-11-openjdk-amd64'
dc_tools_dir = ('/usr/Siemens/DeploymentCenter/webserver'
                '/additional_tools/internal/dc_quick_deploy')
dc_url = 'http://localhost:8080/deploymentcenter'
dc_pwd_file = '/usr/Siemens/DeploymentCenter/downloads/deployment_center/dcadmin.pwf'
dc_scripts_dir = '/usr/Siemens/DeploymentCenter/repository/deploy_scripts'
sync_script = '/usr/local/bin/sync_deployment_scripts.sh'
region = ''
installation_prefix = ''
cicd_bucket = ''
output_filename = ''
web_dns = ''
coords_usernames = [
    "fnd0_tcdbserver.fnd0_oracleDBUser",
    "fnd0_corporateserver.fnd0_tcAdminUser",
    "aws2_indexingengine.aws2_machineUser",
    "aws2_indexingengine.aws2_indexingEngineUser",
    "fnd0_serverpool_DBConfig.fnd0_serverManagerOracleDBUser",
    "fnd0_fsc.fnd0_fsc_machineUser",
]


def matches_env(env, tag):
    return (tag['Key'] == 'Env' and
            tag['Value'] == env)


def matches_installation_prefix(tag):
    return (tag['Key'] == 'Installation' and
            tag['Value'] == installation_prefix)


def matches_coords(coords, tag):
    return (tag['Key'] == 'XML-coordinates' and
            tag['Value'] == coords)


def matches_type(t, tag):
    return (tag['Key'] == 'Type' and
            tag['Value'] == t)


def filter_tc_secret(client, coords, resp, env):
    for secret in resp['SecretList']:
        matched_coords = False
        matched_env = False
        matched_installation = False if installation_prefix != '' else True
        for tag in secret['Tags']:
            matched_coords |= matches_coords(coords, tag)
            matched_env |= matches_env(env, tag)
            matched_installation |= matches_installation_prefix(tag)
        if matched_coords and matched_env and matched_installation:
            r = client.get_secret_value(SecretId=secret['ARN'])
            return r['SecretString']


def filter_dc_secret(client, resp, t):
    for secret in resp['SecretList']:
        matched_type = False
        matched_installation = False if installation_prefix != '' else True
        for tag in secret['Tags']:
            matched_type |= matches_type(t, tag)
            matched_installation |= matches_installation_prefix(tag)
        if matched_type and matched_installation:
            r = client.get_secret_value(SecretId=secret['ARN'])
            return r['SecretString']


def get_from_secretsmanager(env_name, coords):
    try:
        client = boto3.client('secretsmanager', region_name=region)
        next_token = None
        while True:
            if next_token is None:
                resp = client.list_secrets(MaxResults=50)
            else:
                resp = client.list_secrets(MaxResults=1, NextToken=next_token)
            clear = filter_tc_secret(client, coords, resp, env_name)
            if clear is not None:
                print('[%s] Got item from secrets manager' % coords)
                return clear
            if 'NextToken' not in resp or resp['NextToken'] == "":
                print('[%s] No secret value found' % coords)
                return None
            next_token = resp['NextToken']
    except Exception as e:
        print('[%s] Exception retrieving secret from Secrets Manager: %s'
              % (coords, e))
        return None


def get_dc_creds():
    try:
        client = boto3.client('secretsmanager', region_name=region)
        response = client.get_secret_value(
            SecretId='/teamcenter/shared/deployment_center/username',
        )
        return response['SecretString']
    except Exception as e:
        print('[%s] Exception retrieving secret from Secrets Manager: %s'
              % (t, e))
        return None


def encrypt_password(coords, clear_pwd):
    proc = None
    try:
        my_env = os.environ.copy()
        my_env["JAVA_HOME"] = java_home
        proc = subprocess.run('%s/dc_quick_deploy.sh -encrypt=%s' %
                              (dc_tools_dir, clear_pwd),
                              check=True,
                              stdout=subprocess.PIPE,
                              stderr=subprocess.STDOUT,
                              shell=True,
                              universal_newlines=True,
                              cwd=dc_tools_dir,
                              env=my_env)
        parts = proc.stdout.split(' ')
        if len(parts) < 3:
            print('[%s] Unexpected output from encrypting secret: %s' %
                  (coords, proc.stdout))
            return None
        return proc.stdout.split(' ')[3].strip()
    except subprocess.CalledProcessError as e:
        print('[%s] Exception encrypting secret: %s' % (coords, e.output))
    except Exception as e:
        if proc is None:
            print('[%s] Exception encrypting secret: %s' % (coords, str(e)))
        else:
            print('[%s] Exception encrypting secret: %s' %
                  (coords, proc.stderr))

        return None


def replace_password(prop, coords, env_name):
    print('[%s] Filling password' % coords)
    pwd = get_from_secretsmanager(env_name, coords)
    if pwd is None:
        return
    print('[%s] Encrypting password' % coords)
    encrypted = encrypt_password(coords, pwd)
    print('[%s] Encrypted password: %s' % (coords, encrypted))
    prop.attrib["value"] = encrypted
    prop.attrib["encrypted"] = "true"


def replace_user(prop, coords, env_name):
    print('[%s] Filling username' % coords)
    user = get_from_secretsmanager(env_name, coords)
    if user is None:
        return
    prop.attrib["value"] = user


def replace_repo(prop, coords, region_name):
    print('[%s] Filling containerRegistry repo' % coords)
    accountID = boto3.client('sts').get_caller_identity().get('Account')
    urlRepo = '%s.dkr.ecr.%s.amazonaws.com' % (accountID, region_name)
    prop.attrib["value"] = urlRepo


def replace_micro(component, prop, env_name):
    if prop.attrib["value"] != 'Kubernetes':
        return
    print('Found Kubernetes orchestrator, changing microservice '
          'node machine name')
    original_machine_name = component.attrib['machine_name']
    domain = '%s.%s' % (original_machine_name.split['.'][-2],
                        original_machine_name.split['.'][-1])
    if installation_prefix != '':
        prefix = '%s-tc-%s' % (installation_prefix, env_name)
    else:
        prefix = 'tc-%s' % env_name
    component.attrib['machineName'] = '%s-build-server.%s' % (prefix, domain)


def save_xml_file(tree):
    ET.indent(tree, space="\t", level=0)
    letters = string.ascii_letters
    file_path = ('/tmp/quick_deploy-%s.xml' %
                 ''.join(random.choice(letters) for i in range(10)))
    print('Saving file to %s' % file_path)
    tree.write(file_path)
    return file_path


def generate_deployment_scripts(file, env_name):
    dc_user = get_dc_creds()
    cmd = ('%s/dc_quick_deploy.sh '
           '-inputFile=%s '
           '-dcusername=%s '
           '-dcpasswordFile="%s" '
           '-dcUrl="%s" '
           '-environment=%s '
           '-mode="import" ' %
           (dc_tools_dir, file, dc_user, dc_pwd_file, dc_url, env_name))
    proc = None
    try:
        my_env = os.environ.copy()
        my_env["JAVA_HOME"] = java_home
        proc = subprocess.run(cmd,
                              check=True,
                              stdout=subprocess.PIPE,
                              stderr=subprocess.STDOUT,
                              shell=True,
                              universal_newlines=True,
                              cwd=dc_tools_dir,
                              env=my_env)
        print(proc.stdout)
        generated_scripts_dir = '%s/%s/install/' % (dc_scripts_dir, env_name)
        for line in proc.stdout.split('\n'):
            if generated_scripts_dir in line:
                return line.split('/')[-1]
        print('Unable to find the string %s in script output' %
              generated_scripts_dir)
        return None
    except subprocess.CalledProcessError as e:
        print('Exception generating TeamCenter installation scripts. '
              'Command: %s, Output: \n%s' % (cmd, e.output))
        return None
    except Exception as e:
        if proc is None:
            print('Exception generating TeamCenter installation scripts. '
                  'Command: %s, Output: \n%s' % (cmd, str(e)))
        else:
            print('Exception generating TeamCenter installation scripts. '
                  'Command: %s, Output: \n%s' % (cmd, proc.stderr))
        return None


def save_to_s3(d, env_name):
    try:
        print('Saving result to S3')
        s3 = boto3.client('s3')
        s3.put_object(Body=d.encode(),
                      Bucket=cicd_bucket,
                      ContentType='text/plain',
                      Key='stage_outputs/03_generate_install_scripts/%s/%s'
                      % (env_name, output_filename))
        cmd = '%s %s' % (sync_script, cicd_bucket)
        print('Syncronizing generated scripts to S3')
        proc = subprocess.run(cmd,
                              check=True,
                              stdout=subprocess.PIPE,
                              stderr=subprocess.STDOUT,
                              shell=True,
                              universal_newlines=True,
                              cwd=dc_tools_dir)
        print(proc.stdout)
    except Exception as e:
        print('Exception saving result to S3: %s' % str(e))


def replace_web_params(component):
    print('Replacing web params with web url %s' % web_url)
    parsed = parse.urlparse(web_url)
    scheme = parsed.scheme
    dns = parsed.netloc.lower()
    port = 80
    if ":" in parsed.netloc:
        dns = parsed.netloc.split(":")[0].lower()
        port = parsed.netloc.split(":")[1]
    for prop in component:
        if 'id' not in prop.attrib:
            continue
        prop_id = prop.attrib["id"]
        if prop_id.endswith("_treeCachePeersHost"):
            prop.attrib["value"] = dns
        elif prop_id.endswith("_tcwebtier.port"):
            prop.attrib["value"] = port
        elif prop_id.endswith("_tcwebtier.protocol"):
            prop.attrib["value"] = scheme
        elif prop_id.endswith("_4tierURI"):
            prop.attrib["value"] = "%s://%s:%s/tc" % (scheme, dns, port)


def get_xml_s3(s3_uri, region):
    """
    Downloads the quick deploy XML file from the S3 location
    specified in the s3_uri parameter.
    Returns two values: the XML file path and an error string, if any.
    """
    s3 = boto3.resource('s3')
    if not s3_uri.startswith('s3://'):
        return None, 'Malformed S3 uri: %s, it should start with "s3://"' % \
               s3_uri
    bucket_name = parse.urlparse(s3_uri).hostname
    print('Bucket: %s' % bucket_name)
    bucket = s3.Bucket(bucket_name)
    s3_path = parse.urlparse(s3_uri).path.lstrip('/')
    try:
        bucket = s3.Bucket(bucket)
        destf = ('%s%squick_deploy.xml' % (tempfile.gettempdir(), os.path.sep))
        print('Downloading from %s to %s' % (s3_path, destf))
        s3.meta.client.download_file(bucket_name, s3_path, destf)
        return destf, None
    except Exception as e:
        return None, 'Got error downloading or reading XML file: %s' % e


def process_file(file_path, region):
    file_path, err = get_xml_s3(file_path, region)
    if err:
        raise Exception('Error downloading quick deploy file from S3: %s'
                        % err)
    tree = ET.parse(file_path)
    root = tree.getroot()
    env_name = root.attrib["configName"]
    for c in root.findall("quickDeployComponents/component"):
        for prop in c:
            if 'id' not in prop.attrib:
                continue
            comp_id = c.attrib["id"]
            prop_id = prop.attrib["id"]
            coords = '%s.%s' % (comp_id, prop_id)
            if coords == 'fnd0_microservice.fnd0_containerRegistry':
                print('updating url repo')
                replace_repo(prop, coords, region_name=region)
#            if coords == 'fnd0_microservice.fnd0_microservice_url':
#                print('updating microservice machine name if needed')
#                replace_micro(c, prop, env_name)
            if coords in coords_usernames:
                replace_user(prop, coords, env_name)
            if ('value' in prop.attrib
               and 'encrypted' in prop.attrib):
                value = prop.attrib["value"]
                encrypted = prop.attrib["encrypted"]
                if value != 'REPLACEME' or encrypted != 'false':
                    continue
                replace_password(prop, coords, env_name)
    file = save_xml_file(tree)
    d = generate_deployment_scripts(file, env_name)
    if d is not None:
        print('======> Generated scripts dir:\n%s' % d)
        save_to_s3(d, env_name)
    else:
        print('======> ERROR, scripts not generated')
        raise Exception('======> ERROR, scripts not generated \n%s' % d) 


if __name__ == "__main__":
    region = sys.argv[1]
    installation_prefix = sys.argv[2]
    cicd_bucket = sys.argv[3]
    output_filename = sys.argv[4]
    web_dns = sys.argv[5]
    s3_file_path = sys.argv[6]
    print('Region: %s' % region)
    print('Installation prefix: %s' % installation_prefix)
    print('CI/CD bucket: %s' % cicd_bucket)
    print('Output filename: %s' % output_filename)
    print('Web dns: %s' % web_dns)
    print('S3 file path: %s' % s3_file_path)
    process_file(s3_file_path, region)
