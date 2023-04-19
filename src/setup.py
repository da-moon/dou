import re
from setuptools import setup, find_packages
import platform
import os
# Platform Constants
LINUX, MAC, WINDOWS = "Linux", "Darwin", "Windows"

SHORT_DESCRIPTION = "Tired of managing hundreds or thousands of configurations as your microservice footprint " \
                    "scales? Tired of config files, environment variables, poorly managed secrets, and " \
                    " constantly crashing containers due to configuration mismanagement? There’s a better way. Dwarf!"

with open('dwarfcli/config/constants.py') as file:
    contents = file.read()
    VERSION = re.search(r'^VERSION\s*=\s*["\'](.*)["\']', contents, re.MULTILINE)
    GITHUB = re.search(r'^DWARF_GITHUB\s*=\s*["\'](.*)["\']', contents, re.MULTILINE)

VERSION = VERSION.group(1)
GITHUB = GITHUB.group(1)
DWARF_WEBSITE = "https://dwarf.dev"

base_requirements = [
        "boto3 >= 1.13.19",
        "prompt_toolkit == 2.0.7",
        "sty >= 1.0.0b8",
        "click >= 7.1.2",
        "tqdm >= 4.46.0",
        "npyscreen >= 4.10.5",
        "beautifulsoup4 >= 4.9.1",
        "keyring >= 21.2.1",
        "keyrings.alt >= 3.4.0",
        "tabulate >= 0.8.7",
        "jsonpickle >= 1.4.1",
        "urllib3 >= 1.25.7",
        "pyotp >= 2.3.0",
        "pydantic >= 1.5.1",
        "python-u2flib-host>=3.0.3",
        "pycryptodome>=3.9.7",
        "filelock>=3.0.12",
        "pygments>=2.6.1",
        "packer.py"
]

windows_requirements = [
    "pyreadline>=2.1",
    "windows-curses>=2.1.0",
    "pywin32",
]

linux_requirements = [
]

darwin_requriements = [
]

if platform.system() == WINDOWS:
    requirements = base_requirements + windows_requirements
elif platform.system() == LINUX:
    requirements = base_requirements + linux_requirements
elif platform.system() == MAC:
    requirements = base_requirements + darwin_requriements
else:
    requirements = base_requirements + linux_requirements

if os.environ.get('DWARF_TEST') == 'true':
    excludes = []
else:
    excludes = ["test"]

LONG_DESCRIPTION = """

# Dwarf

Cultivate configuration clarity with Dwarf. Open-source, cloud-native, configuration & secret management in AWS.

**Learn everything you need to know about Dwarf by checking out the website:**

https://www.dwarf.dev

Join our Slack community:

https://slack.dwarf.dev

### Dwarf is now in beta!

Dwarf is a **_free_** and **_opensource_** serverless application config framework designed to bring simplicity, security, and resilience to
application config management. Dwarf is built on top of AWS ParameterStore and leverages native AWS constructs such as AWS IAM,
KMS, among other services to ensure a simple and elegant integration with your AWS environment.
<br/>

> **Never roll another application to production having forgotten to set that last pesky
config in production.**


Dwarf makes it possible to **bind your code directly to configurations**. Easily break builds if configs
are missing and application deployments are destined to fail.


> **Control user access like a champ**


Dwarf makes it easy to set up and control access to across all of your AWS environments and configuration namespaces. Consider
your role types and use cases, map them up in a simple config file, and let Dwarf do the rest. Audit all user activity and
changes over time, and roll back any config or group of configurations to any point-in-time -- to the second!


> **Integrate with your SSO provider, abandon long-lived AWS Keys for good**


Dwarf supports SAML based SSO integrations with multi-factor authentication. Simplify AWS access control with Dwarf!


> **Feature rich CLI to speed-up your development workflow.**

<br/>


#### Get a configuration
![Dwarf Get](.assets/gifs/get.gif)

#### Browse the Fig Orchard
![Dwarf Get](.assets/gifs/browse.gif)


#### Validate your configurations exist before deploying
![Dwarf Validate](.assets/gifs/validate.gif)


**Dwarf will help you:**

- Establish secure best practices from the start
- Prevent failed deployments and application downtime due to configuration mismanagmeent
- Save you time by automating simple configuration management tasks
- Give you peace of mind through high availability and resiliency, versioned configurations, audit logs, and easy rollbacks or restores.
- Keep secrets with their owners by cutting out the middle-man and establishing a strong framework of least-privilege.
- Avoid 3rd party lock-in or external dependencies -- Dwarf deploys serverlessly into your AWS environments
- Keep your configuration store tidy. No more unused or stray configurations causing ongoing confusion.


## Why Dwarf?

#### Simple & secure config and secret management
As your cloud footprint grows, so do the configurations you need to manage your applications.
Dwarf is a framework for simple, secure, and resilient config management in AWS. The best part? No new servers to
deploy, upgrade, and patch. No complex software to learn. Follow Dwarf’s laid-out path for config management.
It’s AWS native, compatible with all AWS services, and follows AWS best practices. Let Dwarf help you get it right from the start.

---
#### Prevent downtime due to config mismanagement
Dwarf provides a suite of utilities that link your code to your configs.
Detect and remedy misconfigurations before deployment rather than scrambling after the alarm bells are going off.

---
#### Let the secret owners own the secrets
Dwarf establishes a framework for teams of secret owners to securely track, manage, and rotate their secrets in their
team’s secure space. From that space they can share secrets directly with the applications that need them --
without going through a middle-man. No more LastPass, one-time urls, secrets sent over Slack, email, encrypted files,
or any of those annoying secret management hoops. In a few weeks, when your coworker "Bill" finds new employment,
don’t ask yourself, "What secrets passed through Bill that we need to rotate now?"

---
#### Easily manage and maintain least privilege
Dwarf makes it easy to give both users and applications the exact amount of access they need and nothing more, and provides
a framework for scalably maintaining and enforcing least privilege. By following Dwarf best
practices you can easily maintain appropriate access for users and services while keeping your IAM policies short and sweet.

---
#### Maximum visibility & resiliency
Dwarf maintains a history of every event that has ever occurred in your configuration store since the day you
installed Dwarf. Know what happened, where, when, and by who. Then, roll back any configuration,
or hierarchy of configurations, to any point-in-time in the past, to the second.


Want to dip your toes in and test out the waters? Try out our free [Sandbox](https://www.dwarf.dev/getting-started/sandbox/)
"""

setup(
    name="dwarf-cli",
    packages=find_packages(".", exclude=excludes),
    entry_points={
        "console_scripts": ['dwarf = dwarfcli.entrypoint.cli:main']
    },
    version=VERSION,
    description=SHORT_DESCRIPTION,
    long_description=LONG_DESCRIPTION,
    long_description_content_type="text/markdown",
    author="Sam Flint",
    author_email="fewknow@dwarf.dev",
    url=DWARF_WEBSITE,
    python_requires='>=3.7',
    install_requires=requirements,
    classifiers=[
        "Programming Language :: Python :: 3",
        "Environment :: Console",
        'Intended Audience :: Developers',
        "License :: OSI Approved :: Apache Software License",
        "Operating System :: OS Independent",
        "Natural Language :: English",
        "Programming Language :: Python :: 3.5",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: Implementation",
        "Topic :: Terminals",
        "Topic :: Utilities",
    ]
)
