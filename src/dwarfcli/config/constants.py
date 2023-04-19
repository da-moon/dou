from pathlib import Path

VERSION = '0.0.1'
CLI_NAME = 'dwarf'
PROJECT_NAME = 'dwarf'

# Dwarf URLS
DWARF_GITHUB = "https://github.com/DigitalOnUs/dwarf-cli"

# Paths
DWARF_ERROR_REPORTING_URL = f"{DWARF_OBS_API_BASE_URL}/v1/log-error"
DWARF_GET_VERSION_URL = f"{DWARF_OBS_API_BASE_URL}/v1/version"
DWARF_LOG_METRICS_URL = f"{DWARF_OBS_API_BASE_URL}/v1/log-metrics"

# DOCS URLS
DOCS_URL = 'https://www.dwarf.dev/docs'
INSTALL_URL = f'{DOCS_URL}/getting-started/install/'

# Homebrew
BREW_FORMULA = 'figtools/dwarf/dwarf'

# Role names are assumed to be prefixed with `dwarf-` - Users may override by setting the below ENV variable.
DWARF_ROLE_NAME_PREFIX = 'dwarf-'
DWARF_ROLE_PREFIX_OVERRIDE_ENV = 'DWARF_ROLE_PREFIX_OVERRIDE'

# Table-specific Constants
REPL_TABLE_NAME = "dwarf-config-replication"
REPL_DEST_KEY_NAME = "destination"
REPL_RUN_ENV_KEY_NAME = "env_alias"
REPL_SOURCE_ATTR_NAME = "source"
REPL_NAMESPACE_ATTR_NAME = "namespace"
REPL_TYPE_ATTR_NAME = "type"
REPL_TYPE_APP = "app"
REPL_TYPE_MERGE = "merge"
REPL_USER_ATTR_NAME = "user"

AUDIT_TABLE_NAME = "dwarf-config-auditor"
AUDIT_PARAMETER_KEY_NAME = "parameter_name"
AUDIT_TIME_KEY_NAME = "time"
AUDIT_ACTION_ATTR_NAME = "action"
AUDIT_USER_ATTR_NAME = "user"

CACHE_TABLE_NAME = 'dwarf-config-cache'
CACHE_PARAMETER_KEY_NAME = "parameter_name"
CACHE_LAST_UPDATED_KEY_NAME = "last_updated"
CACHE_STATE_ATTR_NAME = 'state'
AUDIT_PARAMETER_ATTR_TYPE = "type"
AUDIT_PARAMETER_ATTR_VERSION = "version"
AUDIT_PARAMETER_ATTR_DESCRIPTION = "description"
AUDIT_PARAMETER_ATTR_VALUE = "value"
AUDIT_PARAMETER_ATTR_KEY_ID = "key_id"

# Merge Key constants
MERGE_KEY_PREFIX = "${"
MERGE_KEY_SUFFIX = "}"

# SSM Constants
SSM_SECURE_STRING = "SecureString"
SSM_STRING = "String"
SSM_PUT = 'PutParameter'
SSM_DELETE = 'DeleteParameter'

# Other PS Config constants
DEPLOY_GROUPS_PS_PREFIX = '/shared/deploy-groups/'

# dwarf.json json keys
REPLICATION_KEY = 'replicate_figs'
MERGE_KEY = 'merged_figs'
CONFIG_KEY = 'app_figs'
SHARED_KEY = 'shared_figs'
REPOSITORY_KEY = "repositories"
IMPORTS_KEY = 'import'
OPTIONAL_NAMESPACE = 'twig'
REPL_FROM_KEY = 'replicate_from'
SOURCE_NS_KEY = 'source_twig'
PARAMETERS_KEY = 'parameters'
SERVICE_KEY = 'service'
PLUGIN_KEY = 'plugins'

# Config paths
PS_DWARF_ACCOUNTS_PREFIX = '/dwarf/accounts/'
PS_DWARF_DEFAULT_SERVICE_NS_PATH = '/dwarf/defaults/service-namespace'

# Replication Types:
repl_types = [REPL_TYPE_APP, REPL_TYPE_MERGE]

# File names / paths
HOME = str(Path.home())
DECRYPTER_S3_PATH_PREFIX = f'dwarf/decrypt/'
AWS_CREDENTIALS_FILE_PATH = f'{HOME}/.aws/credentials'
AWS_CONFIG_FILE_PATH = f'{HOME}/.aws/config'
CACHE_OTHER_DIR = f'{HOME}/.dwarf/cache/other'
DEFAULT_INSTALL_PATH = '/usr/local/bin/dwarf'
ERROR_LOG_DIR = f'{HOME}/.dwarf/errors'
CONFIG_OVERRIDE_FILE_PATH = f'{HOME}/.dwarf/config'
DEFAULTS_FILE_CACHE_PATH = f'{CACHE_OTHER_DIR}/defaults.json'
CONFIG_CACHE_FILE_PATH = f'{CACHE_OTHER_DIR}/config-cache.json'
STS_SESSION_CACHE_PATH = f"{HOME}/.dwarf/lockbox/sts/sessions"
SAML_SESSION_CACHE_PATH = f"{HOME}/.dwarf/lockbox/sso/saml"
OKTA_SESSION_CACHE_PATH = f"{HOME}/.dwarf/cache/okta/session"
GOOGLE_SESSION_CACHE_PATH = f"{HOME}/.dwarf/cache/google/session"
DWARF_LOCK_FILE_PATH = f"{HOME}/.dwarf/lock"

# Defaults file keys
DEFAULTS_ROLE_KEY = 'role'
DEFAULTS_ENV_KEY = 'default_env'
DEFAULTS_COLORS_ENABLED_KEY = 'colors'
DEFAULTS_USER_KEY = 'user'
DEFAULTS_PROVIDER_KEY = 'provider'
DEFAULTS_PROFILE_KEY = 'profile'
DEFAULTS_REGION_KEY = 'region'
MFA_SERIAL_KEY = 'mfa_serial'
DEFAULTS_KEY = 'defaults'

# Cache File keys
OKTA_SESSION_TOKEN_CACHE_KEY = 'session_token'
OKTA_SESSION_ID_CACHE_KEY = 'session_id'

# Plaform Constants
LINUX = "Linux"
MAC = "Darwin"
WINDOWS = "Windows"
ROOT_USER = "root"

# Build configs
OVERRIDE_KEYRING_ENV_VAR = "OVERRIDE_KEYRING"
ONE_WEEK_SECONDS = 60 * 60 * 24 * 7

# Dwarf Sandbox
SANDBOX_ROLES = ['dev', 'devops', 'sre', 'data', 'dba']
GET_SANDBOX_CREDS_URL = "https://q39v8f3u13.execute-api.us-east-1.amazonaws.com/sandbox-bastion/v1/get-credentials"
DWARF_SANDBOX_REGION = 'us-east-1'
DWARF_SANDBOX_PROFILE = 'dwarf-sandbox'
DISABLE_KEYRING = 'disable-keyring'
SANDBOX_DEV_ACCOUNT_ID = '880864869599'

# Guaranteed Namespaces
shared_ns = '/shared'
dwarf_ns = '/dwarf'

# PS PATHS:
ACCOUNT_ID_PATH = f'{dwarf_ns}/account_id'

# Vault
DWARF_VAULT_FILES = [OKTA_SESSION_CACHE_PATH, GOOGLE_SESSION_CACHE_PATH, STS_SESSION_CACHE_PATH, SAML_SESSION_CACHE_PATH]

# Environment Variables
APP_NS_OVERRIDE = 'DWARF_APP_TREE_OVERRIDE'
DWARF_DISABLE_KEYRING = 'DWARF_DISABLE_KEYRING'  # used for automated tests.

# Keychain
KEYCHAIN_ENCRYPTION_KEY = 'dwarf-encryption-key'

# This is only used for temporary sandbox sessions. This reduces user friction when experimenting by not having to
# interact with authenticating their OS Keychain.
DEFAULT_ENCRYPTION_KEY = 'wX1C0nK1glfzaWQU8SKukdS7XZgYlAMW5ueb_V3cfSE='

# Default paths to search for dwarf.json in
DEFAULT_DWARF_JSON_PATHS = ['dwarf.json', 'dwarf/dwarf.json', 'config/dwarf.json', '_dwarf/dwarf.json', '.dwarf/dwarf.json']
