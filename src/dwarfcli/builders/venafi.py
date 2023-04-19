""" Venafi Management """
from __future__ import print_function
import json
import os
import time
import requests
from Crypto.PublicKey import RSA

class Docker(object):
    """
    This class is used to perform native venafi
    helper tasks for certification creation/deletion
    """

    def __init__(self, confg_file, output_file, san_file):
        with open(confg_file, 'r') as _f:
            config = json.load(_f)

        # sanity check
        if config:
            print("Checking certification type")
            if (config['certificate_type'] == "") or \
            (config['certificate_type'] is None) or \
            (config['certificate_type'] == "jks"):
                config['certificate_type'] = 'jks'
                print("jks cert type")
            elif config['certificate_type'] == 'pem':
                print("pem cert type")
            else:
                print("Certification type unknown")
            self.config = config
            self.output_file = output_file
            self.san_file = san_file
            self.cert_password = self.config['cert_password']

    def _retrieve_cert(self, api_key, common_name, policy_dn):
        cert_ready = False
        headers = {'X-Venafi-Api-Key': api_key,
                   'Cache-Control': 'no-cache',
                   'Content-Type': 'application/json'}
        while not cert_ready:
            # This Curl returns a 200 if the certificate is ready.
            # If we requested a cert, it might not be ready for 60-120 seconds
            headers = {'X-Venafi-Api-Key': api_key,
                       'Cache-Control': 'no-cache',
                       'Content-Type': 'application/json'}
            url = "{venafi_host}/Certificates/Retrieve?CertificateDN={p}\\{commonname}&format=Base64".format(
                venafi_host=VENAFI_HOST, commonname=common_name, p=policy_dn)
            print("URL : {u}".format(u=url))
            response = requests.get(url, headers=headers, verify=False)
            print("Looking for : {n}".format(n=common_name))
            print("RESPONSE : ")
            print(response.text)
            print(response.reason)
            print(response.status_code)

            if response.status_code == 400 or response.status_code == 500:
                print("Something went wrong. Please fix")
                print(response.text)
                print(response.reason)
                print(response.status_code)
                raise Exception(
                    "Error Getting cert: {e}".format(e=response.reason))

            elif response.status_code == 200:
                print("Still checking")
                print(response.text)
                print(response.reason)
                print(response.status_code)
                cert_ready = True
            # TODO WE NEED TO PUT A TIMEOUT AND ERROR MESSAGE AROUND THIS
            time.sleep(5)

        retries = 10
        is_key_valid_bundle = False
        is_key_valid_key = False
        is_key_valid_cert = False

        bundle_url = "{venafi_host}/Certificates/Retrieve?CertificateDN={p}\\{commonname}&IncludeChain=true&IncludePrivateKey=true&FriendlyName=AutoGenCert&Password={certpass}&format=Base64".format(
            venafi_host=VENAFI_HOST, commonname=common_name, p=policy_dn, certpass=self.cert_password)
        key_url = "{venafi_host}/Certificates/Retrieve?CertificateDN={p}\\{commonname}&IncludePrivateKey=true&FriendlyName=AutoGenCert&Password={certpass}&format=Base64".format(
            venafi_host=VENAFI_HOST, commonname=common_name, p=policy_dn, certpass=self.cert_password)
        cert_url = "{venafi_host}/Certificates/Retrieve?CertificateDN={p}\\{commonname}&FriendlyName=AutoGenCert&format=Base64".format(
            venafi_host=VENAFI_HOST, commonname=common_name, p=policy_dn)

        print("URL : {u}".format(u=url))

        while not is_key_valid_bundle:
            response = requests.get(
                bundle_url, headers=headers, verify=False, stream=True)
            # Throw an error for bad status codes
            response.raise_for_status()
            output_file = "{w}/{n}-ca_bundle.crt".format(
                w=self.output_file, n=common_name)
            with open(output_file, 'wb') as handle:
                for block in response.iter_content(1024):
                    handle.write(block)

            if os.stat(output_file).st_size != 0:
                is_key_valid_bundle = True
                print("Successfully retrieved cert")
            else:
                # Key is not valid
                if retries == 0:
                    print(
                        "Failed to successfully get key from Venafi. Rerun the job or reach out to ITPlatforms-ContinuousDelivery@qvc.com")
                    retries = retries - 1
                    time.sleep(10)
                    print("{retries} venafi retries remaining to get valid key".format(
                        retries=retries))

        while not is_key_valid_key:
            response = requests.get(
                key_url, headers=headers, verify=False, stream=True)
            # Throw an error for bad status codes
            response.raise_for_status()
            output_file = "{w}/{n}.key".format(
                w=self.output_file, n=common_name)
            with open(output_file, 'wb') as handle:
                for block in response.iter_content(1024):
                    handle.write(block)

            if os.stat(output_file).st_size != 0:
                is_key_valid_key = True
                print("Successfully retrieved cert")
            else:
                # Key is not valid
                if retries == 0:
                    print(
                        "Failed to successfully get key from Venafi. Rerun the job or reach out to ITPlatforms-ContinuousDelivery@qvc.com")

                    retries = retries - 1
                    time.sleep(10)
                    print("{retries} venafi retries remaining to get valid key".format(
                        retries=retries))

        while not is_key_valid_cert:
            response = requests.get(
                cert_url, headers=headers, verify=False, stream=True)
            # Throw an error for bad status codes
            response.raise_for_status()
            output_file = "{w}/{n}.crt".format(
                w=self.output_file, n=common_name)
            with open(output_file, 'wb') as handle:
                for block in response.iter_content(1024):
                    handle.write(block)

            if os.stat(output_file).st_size != 0:
                is_key_valid_cert = True
                print("Successfully retrieved cert")
            else:
                # Key is not valid
                if retries == 0:
                    print(
                        "Failed to successfully get key from Venafi. Rerun the job or reach out to ITPlatforms-ContinuousDelivery@qvc.com")

                    retries = retries - 1
                    time.sleep(10)
                    print("{retries} venafi retries remaining to get valid key".format(
                        retries=retries))

            return

    @staticmethod
    def _request_cert(api_key, cert_json):
        headers = {'X-Venafi-Api-Key': api_key,
                   'Cache-Control': 'no-cache', 'Content-Type': 'application/json'}
        url = "{venafi_host}/Certificates/Request".format(
            venafi_host=VENAFI_HOST)
        print("URL : {u}".format(u=url))
        response = requests.post(url, headers=headers,
                                 data=cert_json, verify=False)

        return response.json()

    def _create_cert_json(self, common_name, policy_dn):
        # load subject alt names (SANs) from json file
        sans_json_file = open(self.san_file)
        subject_alt_names = json.load(sans_json_file)
        sans_json_file.close()

        venafi_cert_json = {
            "PolicyDN": policy_dn,
            "ObjectName": common_name,
            "Subject": common_name,
            "SubjectAltNames": subject_alt_names
        }

        return json.dumps(venafi_cert_json)

    # Each cert has a GUID associated with it. This is used as a unique identifier when referenced
    @staticmethod
    def _delete_cert(guid, api_key):
        headers = {'Content-type': 'application/json',
                   'X-Venafi-Api-Key': api_key, 'Cache-Control': 'no-cache'}
        url = "{v}/Certificates/{g}".format(v=VENAFI_HOST, g=guid)
        print("URL : {u}".format(u=url))
        response = requests.delete(url, headers=headers, verify=False)
        print("Response : ")
        print(response.text)
        print(response.status_code)

    def _get_api_token(self):
        venafi_creds_json = {
            "Username": self.config['venuser'], "Password": self.config['venpass']}
        creds = json.dumps(venafi_creds_json)
        url = "{v}/authorize/".format(v=VENAFI_HOST)
        print("URL : {u}".format(u=url))
        headers = {'Cache-Control': 'no-cache',
                   'Content-Type': 'application/json'}
        response = requests.post(url, headers=headers,
                                 data=creds, verify=False)
        print("Response : ")
        print(response.text)
        print(response.status_code)
        venafi_auth_token_json = response.json()
        return venafi_auth_token_json['APIKey']

    def _verify_cert_exists(self, common_name, venafi_api_key):
        print("check if {c} exists".format(c=common_name))
        headers = {'Cache-Control': 'no-cache',
                   'Content-Type': 'application/json', "X-Venafi-Api-Key": venafi_api_key}
        url = "{venafi_host}/Certificates/?CN=${commonname}".format(
            venafi_host=VENAFI_HOST, commonname=common_name)
        response = requests.get(url, headers=headers, verify=False)

        venafi_search_json = response.json()
        venafi_search_results = venafi_search_json['Certificates']

        if venafi_search_results:
            guid = venafi_search_results[0].Guid
            print("Deleting current cert for {c}".format(c=common_name))
            self._delete_cert(guid, venafi_api_key)

    def _read_public_certificate(self, common_name):
        with open("{o}/{n}.crt".format(o=self.output_file, n=common_name)) as crt_file:
            return crt_file.read()

    def _decrypt_private_key(self, common_name):
        print("Decrypting certificate...")
        with open("{o}/{n}.key".format(o=self.output_file, n=common_name), "r+") as key_file:

            certificate_content = self._read_public_certificate(common_name)

            # RSA library cannot read the key file when it is bundled with the public key
            separated_key_content = key_file.read().replace(certificate_content, '')
            rsa_key = RSA.importKey(
                separated_key_content, passphrase=self.cert_password)

            decrypted_content = rsa_key.exportKey(
                format='PEM', passphrase=None, pkcs=1, protection=None, randfunc=None).decode('utf-8')

            key_file.seek(0)
            key_file.write(decrypted_content)
            key_file.truncate()

    def _create_consul_venafi_cert(self, common_name, is_decrypted):
        print("Creating certificate process......")

        print("Get API token")
        api_token = self._get_api_token()

        print("Check if cert exists")
        self._verify_cert_exists(common_name, api_token)

        print("Create Json Cert")
        cert_json = self._create_cert_json(
            common_name, self.config['consul_policy_dn'])

        print("Requesting Cert")
        request = self._request_cert(api_token, cert_json)

        print("Response : {r}".format(r=request))

        print("Retrieve Cert")
        self._retrieve_cert(api_token, common_name,
                            self.config['consul_policy_dn'])

        if is_decrypted:
            self._decrypt_private_key(common_name)

    def _create_vault_venafi_cert(self, common_name, is_decrypted):
        print("Creating certificate process......")

        print("Get API token")
        api_token = self._get_api_token()

        print("Check if cert exists")
        self._verify_cert_exists(common_name, api_token)

        print("Create Json Cert")
        cert_json = self._create_cert_json(
            common_name, self.config['vault_policy_dn'])

        print("Requesting Cert")
        request = self._request_cert(api_token, cert_json)

        print("Response : {r}".format(r=request))

        print("Retrieve Cert")
        self._retrieve_cert(api_token, common_name,
                            self.config['vault_policy_dn'])

        if is_decrypted:
            self._decrypt_private_key(common_name)


# FOR TESTING
# test = Certs('config.json', 'output', 'subject_alt_names.json')
# test.CreateConsulVenafiCert("vc-355-test", True)
# test.CreateVaultVenafiCert("vc-355-test", True)
