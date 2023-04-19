import os
import consul
import json
import hvac
import vault_cli
import psycopg2

from vault12factor import \
    VaultCredentialProvider, \
    VaultAuth12Factor, \
    DjangoAutoRefreshDBCredentialsDict

def get_consul_value(cnsl, key):
    byte_str = cnsl.kv.get(key)[1]['Value']
    data = byte_str.decode("UTF-8")
    return data

def get_vault_secret(vault_client, key, spath):
    return vault_client.secrets.kv.v1.read_secret(
           path=spath)['data'][key]

def set_connection():
    
    DB_VALUES = get_db_values()
    conn = psycopg2.connect(
        database=DB_VALUES['db_name'],
        user=DB_VALUES['db_user'],
        password=DB_VALUES['db_pass'],
        host= DB_VALUES['db_host'],
        port= DB_VALUES['db_port']
    )
    return conn

def get_db_values():
    CONSUL = consul.Consul(os.getenv("CONSUL_DEV_LISTEN_ADDRESS", 'localhost'),
                             token=os.getenv('CONSUL_TOKEN')) 
    VAULT_CLIENT = hvac.Client(url='http://'+os.getenv("VAULT_DEV_LISTEN_ADDRESS",
                                    "127.0.0.1")+':8200' \
                                    , token=os.environ['VAULT_TOKEN'],)
    DATABASE_NAME = get_consul_value(CONSUL, 'POSTGRESQL_NAME')
    DATABASE_USER = get_consul_value(CONSUL, 'POSTGRES_USER')
    DATABASE_PASSWORD = get_vault_secret(VAULT_CLIENT, 'POSTGRESQL_PASS'
                                , os.getenv("KEYS_DIR","django_secrets"))
    DATABASE_HOST = get_consul_value(CONSUL,'POSTGRESQL_HOST')
    DATABASE_PORT = get_consul_value(CONSUL,'POSTGRESQL_PORT')
    return {'db_name': DATABASE_NAME,
            'db_user': DATABASE_USER,
            'db_pass': DATABASE_PASSWORD,
            'db_host': DATABASE_HOST,
            'db_port': DATABASE_PORT
            }

try:

    conn = set_connection()

    cursor = conn.cursor()
    os.system('python manage.py migrate')
    os.system('''python manage.py create_admin_user \
    --user=admin \
    --password=admin \
     --email=admin@admin.com''')
except Exception as e:
    print(f'Cannnot connect to database { e }')