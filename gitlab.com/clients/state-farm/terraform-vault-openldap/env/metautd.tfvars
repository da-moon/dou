mount_point = "openldap-db2"
mount_description = "OpenLDAP secret engine mount"
ldap_password_policy = "vault-db2-password-policy"
ldap_password_length = 14
ldap_server_binddn = "ou=hcvault_db2_users,O=STATEFARM,C=US"
#ldap_server_bindpass = ""
ldap_server_url = ["ldaps://ldap-sbx.opr.test.statefarm.org:2636"]
ldap_server_schema = "openldap"
ldap_server_request_timeout = 90
ldap_starttls = false
vault_data_path = ""
#ldap_client_ca_certificate_path = "files/sf-bundle.crt"
ldap_client_tls_cert_path = ""
ldap_client_tls_key_path = ""
dynamic_credentials_role_name = "metautd-readonly-db2role"
dynamic_credentials_role_username_template = ""
dynamic_credentials_role_default_ttl = ""
dynamic_credentials_role_max_ttl = ""