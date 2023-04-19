from tornado.ioloop import IOLoop
from tornado.gen import coroutine
from consul.base import Timeout
import psycopg2
import consul
import hvac
import os
import vault_cli
import psycopg2
from vault12factor import \
    VaultCredentialProvider, \
    VaultAuth12Factor, \
    DjangoAutoRefreshDBCredentialsDict
import sys
sys.path.insert(1, '../')


def get_consul_value(key, csnl=None):
    global CONSUL
    if csnl is None:
        cnsl = CONSUL
    byte_str = cnsl.kv.get(key)[1]['Value']
    data = byte_str.decode("UTF-8")
    return data


def get_vault_secret(vault_client, key, spath):

    try:
        secret = vault_client.secrets.kv.v1.read_secret(
            path=spath)['data'][key]
    except Exception:
        secret = vault_client.secrets.kv.v2.read_secret_version(
            path=spath)['data']['data'][key]

    return secret


class Config(object):
    def __init__(self, loop):
        self.postgresql_name = None
        self.postgresql_host = None
        self.postgresql_port = ''
        self.postgresql_user = ''

        self.postgresql_pass = ''
        self.rabbitmq_pass = ''
        self.django_secret_key = ''

        loop.add_callback(self.watch)

    @coroutine
    def watch(self):
        c = consul.Consul(os.getenv("CONSUL_DEV_LISTEN_ADDRESS", 'localhost'),
                          token=os.getenv('CONSUL_TOKEN'))
        VAULT_CLIENT = hvac.Client(url='http://' + os.getenv("VAULT_DEV_LISTEN_ADDRESS",
                                                             "127.0.0.1") + ':8200', token=os.environ['VAULT_TOKEN'],)

        # asynchronously poll for updates
        index = None
        while True:
            try:
                print('data updated')
                data_postgres_name = yield get_consul_value('POSTGRESQL_NAME', c)
                if data_postgres_name is not None:
                    self.postgresql_name = data_postgres_name

                data_postgres_host = yield get_consul_value('POSTGRESQL_HOST', c)
                if data_postgres_host is not None:
                    self.postgresql_host = data_postgres_host

                data_postgres_port = yield get_consul_value('POSTGRESQL_PORT', c)
                if data_postgres_port is not None:
                    self.postgresql_port = data_postgres_port

                data_postgresql_user = yield get_consul_value('POSTGRES_USER', c)
                if data_postgresql_user is not None:
                    self.postgresql_port = data_postgresql_user

                data_postgresql_pass = yield get_vault_secret(VAULT_CLIENT, 'POSTGRESQL_PASS')
                if data_postgresql_pass is not None:
                    self.postgresql_pass = data_postgresql_pass

                data_rabbitmq_pass = yield get_vault_secret(VAULT_CLIENT, 'RABBITMQ_PASSWORD')
                if data_rabbitmq_pass is not None:
                    self.rabbitmq_pass = data_rabbitmq_pass

                data_django_secret_key = yield get_vault_secret(VAULT_CLIENT, 'DJANGO_SECRET_KEY')
                if data_django_secret_key is not None:
                    self.django_secret_key = data_django_secret_key

                print(f'''new values:
                    NAME: {data_postgres_name}
                    HOST: {data_postgres_host}
                    PORT: {data_postgres_port}
                    ''')
            except Timeout:
                # gracefully handle request timeout
                pass


def set_connection():

    DB_VALUES = get_db_values()
    conn = psycopg2.connect(
        database=DB_VALUES['db_name'],
        user=DB_VALUES['db_user'],
        password=DB_VALUES['db_pass'],
        host=DB_VALUES['db_host'],
        port=DB_VALUES['db_port']
    )

    print(f'''Is connecting to:
    USER: {DB_VALUES['db_user']}
    HOST: {DB_VALUES['db_host']}
    PORT: {DB_VALUES['db_port']}
    ''')
    return conn


def get_db_values():
    DATABASE_NAME = get_consul_value('POSTGRESQL_NAME')
    DATABASE_USER = get_consul_value('POSTGRES_USER')
    DATABASE_PASSWORD = get_vault_secret(
        VAULT_CLIENT, 'POSTGRESQL_PASS', os.getenv("KEYS_DIR", "django_secrets"))
    DATABASE_HOST = get_consul_value('POSTGRESQL_HOST')
    DATABASE_PORT = get_consul_value('POSTGRESQL_PORT')
    print(f'''Values to connects to:
    USER: {DATABASE_USER}
    HOST: {DATABASE_HOST}
    PORT: {DATABASE_PORT}
    ''')
    return {'db_name': DATABASE_NAME,
            'db_user': DATABASE_USER,
            'db_pass': DATABASE_PASSWORD,
            'db_host': DATABASE_HOST,
            'db_port': DATABASE_PORT
            }


CONSUL = consul.Consul(os.getenv("CONSUL_DEV_LISTEN_ADDRESS", 'localhost'),
                       token=os.getenv('CONSUL_TOKEN'))

VAULT_CLIENT = hvac.Client(url='http://' + os.getenv("VAULT_DEV_LISTEN_ADDRESS",
                                                     "127.0.0.1") + ':8200', token=os.environ['VAULT_TOKEN'],)


VAULT = VaultAuth12Factor.fromenv()

CREDS = VaultCredentialProvider(os.getenv("VAULT_DEV_LISTEN_ADDRESS",
                                          "http://127.0.0.1:8200/"), VAULT, os.getenv("KEYS_DIR",
                                "postgres")
                                )
