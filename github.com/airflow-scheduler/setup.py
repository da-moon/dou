from setuptools import setup

setup(
    name="airlow_libraries",
    version="0.8",
    description="Python library to use with DAGs in Airflow",
    author="DevOps",
    packages=['airlow_libraries'],
    install_requires=[
        "python-nomad",
        "apache-airflow",
        "gitpython",
        "pytest-shutil",
        "python-consul",
        "requests",
        "pymsteams",
        "azure-devops"
    ]
)
