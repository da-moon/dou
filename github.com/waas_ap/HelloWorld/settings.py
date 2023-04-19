"""
Django settings for HelloWorld project.

Generated by 'django-admin startproject' using Django 3.0.8.

For more information on this file, see
https://docs.djangoproject.com/en/3.0/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/3.0/ref/settings/
"""
from tornado.ioloop import IOLoop
import hvac
from . import utils
from vault12factor import \
    DjangoAutoRefreshDBCredentialsDict
import os
import sys
sys.path.insert(1, '../')


os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'HelloWorld.settings')

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SETTINGS_PATH = os.path.dirname(os.path.dirname(__file__))

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/3.0/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['*']
VAULT_CLIENT = hvac.Client(url='http://' +
                           os.getenv("VAULT_DEV_LISTEN_ADDRESS", "127.0.0.1") +
                               ':8200', token=os.environ['VAULT_TOKEN'],)

SECRET_KEY = utils.get_vault_secret(
    VAULT_CLIENT, 'DJANGO_SECRET_KEY', os.getenv("KEYS_DIR", "django_secrets"))

# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'main',
    'els',
    'rabbitmq',
    'bootstrap4',
    'django_elasticsearch_dsl',
    'vault12factor',
]

ELASTICSEARCH_DSL = {
    'default': {
        'hosts': 'elasticsearch:9200'  # if FOR_CONTAINER else 'localhost:9200'
    }
}


LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'simple': {
            'format': '[%(asctime)s] %(levelname)s|%(name)s|%(message)s',
            'datefmt': '%Y-%m-%d %H:%M:%S',
        },
    },
    'handlers': {
        'console': {
            'level': 'INFO',
            'class': 'logging.StreamHandler',
            'formatter': 'simple'
        },
        'logstash': {
            'level': 'DEBUG',
            'class': 'logstash.LogstashHandler',
            'host': 'localhost',
            'port': 5000,  # Default port of logstash
            # Version of logstash event schema. Default value: 0 (for backward
            # compatibility of the library)
            'version': 1,
            # 'type' field in logstash message. Default value: 'logstash'.
            'message_type': 'logstash',
            # Fully qualified domain name. Default value: false.
            'fqdn': False,
            'tags': ['django.request'],  # list of tags. Default: None.
        },
    },
    'loggers': {
        'django.request': {
            'handlers': ['logstash'],
            'level': 'DEBUG',
            'propagate': True,
        },
        'django': {
            'handlers': ['console'],
            'propagate': True,
        },
        'main': {
            'handlers': ['console', 'logstash'],
            'level': 'DEBUG',
        },
        'els': {
            'handlers': ['console', 'logstash'],
            'level': 'DEBUG',
        },
        # 'employees': {
        #     'handlers': ['console', 'logstash'],
        #     'level': 'DEBUG',
        # },
    }
}

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'HelloWorld.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(SETTINGS_PATH, 'templates')],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'django.template.context_processors.media',
            ],
        },
    },
]

WSGI_APPLICATION = 'HelloWorld.wsgi.application'


# Database
# https://docs.djangoproject.com/en/3.0/ref/settings/#databases


DB_VALUES = utils.get_db_values()

try:
    DATABASES = {
        'default': DjangoAutoRefreshDBCredentialsDict(utils.CREDS, {
            'ENGINE': 'django.db.backends.postgresql_psycopg2',
            'NAME': DB_VALUES['db_name'],
            'USER': DB_VALUES['db_user'],
            'PASSWORD': DB_VALUES['db_pass'],
            'HOST': DB_VALUES['db_host'],
            'PORT': DB_VALUES['db_port'],
        }),
    }
except Exception as e:
    print(f'Cannnot connect to database { e }')

# Password validation
# https://docs.djangoproject.com/en/3.0/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/3.0/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True


BOOTSTRAP4 = {

    # The complete URL to the Bootstrap CSS file
    # Note that a URL can be either a string,
    # e.g. "https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css",
    # or a dict like the default value below.
    "css_url": {
        "href": "https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css",
        "integrity": "sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB",
        "crossorigin": "anonymous",
    },

    # The complete URL to the Bootstrap JavaScript file
    "javascript_url": {
        "url": "https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js",
        "integrity": "sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T",
        "crossorigin": "anonymous",
    },

    # The complete URL to the Bootstrap CSS file (None means no theme)
    "theme_url": None,

    # The URL to the jQuery JavaScript file (full)
    "jquery_url": {
        "url": "https://code.jquery.com/jquery-3.3.1.min.js",
        "integrity": "sha384-tsQFqpEReu7ZLhBV2VZlAu7zcOV+rXbYlF2cqB8txI/8aZajjp4Bqd+V6D5IgvKT",
        "crossorigin": "anonymous",
    },

    # The URL to the jQuery JavaScript file (slim)
    "jquery_slim_url": {
        "url": "https://code.jquery.com/jquery-3.3.1.slim.min.js",
        "integrity": "sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo",
        "crossorigin": "anonymous",
    },

    # The URL to the Popper.js JavaScript file (slim)
    "popper_url": {
        "url": "https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js",
        "integrity": "sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49",
        "crossorigin": "anonymous",
    },

    # Put JavaScript in the HEAD section of the HTML document (only relevant
    # if you use bootstrap4.html)
    'javascript_in_head': False,

    # Include jQuery with Bootstrap JavaScript False|falsy|slim|full (default=False)
    # False - means tag bootstrap_javascript use default value - `falsy` and
    # does not include jQuery)
    'include_jquery': False,

    # Label class to use in horizontal forms
    'horizontal_label_class': 'col-md-3',

    # Field class to use in horizontal forms
    'horizontal_field_class': 'col-md-9',

    # Set placeholder attributes to label if no placeholder is provided
    'set_placeholder': True,

    # Class to indicate required (better to set this in your Django form)
    'required_css_class': '',

    # Class to indicate error (better to set this in your Django form)
    'error_css_class': 'has-error',

    # Class to indicate success, meaning the field has valid input (better to
    # set this in your Django form)
    'success_css_class': 'has-success',

    # Renderers (only set these if you have studied the source and understand
    # the inner workings)
    'formset_renderers': {
        'default': 'bootstrap4.renderers.FormsetRenderer',
    },
    'form_renderers': {
        'default': 'bootstrap4.renderers.FormRenderer',
    },
    'field_renderers': {
        'default': 'bootstrap4.renderers.FieldRenderer',
        'inline': 'bootstrap4.renderers.InlineFieldRenderer',
    },
}

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/3.0/howto/static-files/


STATIC_ROOT = 'staticfiles'
STATIC_URL = '/static/'

STATICFILES_FINDERS = [
    'django.contrib.staticfiles.finders.FileSystemFinder',
    # 'django.contrib.staticfiles.finders.AppDirectoriesFinder',
]

STATICFILES_DIRS = [
    os.path.join(BASE_DIR, "static"),
]

MEDIA_URL = '/media/'
MEDIA_DIR = os.path.join(BASE_DIR, 'media')
MEDIA_ROOT = os.path.join(BASE_DIR, 'media/')

TEMPLATE_DIRS = (
    os.path.join(BASE_DIR, 'templates'),
)

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

if __name__ == '__main__':
    loop = IOLoop.instance()
    _ = utils.Config(loop)
    loop.start()