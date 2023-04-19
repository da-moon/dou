# What is Airflow? And How it Can Help with Assurant's Workflow Processes?


# What Variables in Airflow Need to be Changed in Order to Operator Airflow in Model?


# Airflow Custom Operators

Airflow Customer Operators are modules that represent a single, ideally idempotent task. They are arbiters of the logic that executes when your DAG runs.

To get started, below is explains the local development process to get Airflow running in a docker container on your own machine and see how it wall works.

![Airflow Development Process](./images/airflow_custom_operators.png)

---

# Airflow Development Process

## Prequisites

* Based on Python (3.7-slim-buster) official Image [python:3.7-slim-buster](https://hub.docker.com/_/python/) and uses the official [Postgres](https://hub.docker.com/_/postgres/) as backend and [Redis](https://hub.docker.com/_/redis/) as queue
* Install Locally: [Docker](https://www.docker.com/)
* Install Locally: [Docker Compose](https://docs.docker.com/compose/install/)

## Clone Repository.

```
git clone https://github.com/DigitalOnUs/airflow-custom-operators.git
```

## Checkout develop branch

This branch contains the most up-to-date code changes and will be the branch that you will create feature branches from when working within this repo to make changes to operators and helpers.

```
git checkout develop
```

## Build Local Docker Image

```
docker image build -t airflow:v1 .
```

## Verify Docker Image Exists Locally

```
$ docker images
REPOSITORY       TAG        IMAGE ID       CREATED          SIZE
airflow          v1         08775f266c3c   32 minutes ago   800MB
postgres         9.6        7a313171f464   5 weeks ago      200MB
```

## Checkout feature branch

Create a feature branch from develop and you can start making your own changes without affecting any other team members. Use the features branch syntax: {WORK_ITEM_TYPE}-{TICKET-NUMBER}

*for example: STORY-1234*

```
git checkout -b STORY-1234
```

## Run Airflow Containers

By default, docker-airflow runs Airflow with **CeleryExecutor** :

```
docker-compose up
```

## Airflow UI Links

- [LOCAL](http://localhost:8080/)

- [DEV] - need to attach a Load balancer endpoint here to point to Airflow UI

## Azure Blob Storage Links

- [DEV]- need blob storage to deploy files to.

## Configured Airflow Variables:

Go to Admin -> Variables and click Create and past in Key & Value:

![Create Variable](./images/add_assurant_ado_access_token.png)

For encrypted connection passwords (in Local or Celery Executor), you must have the same fernet_key. By default docker-airflow generates the fernet_key at startup, you have to set an environment variable in the docker-compose (ie: docker-compose-LocalExecutor.yml) file to set the same key accross containers. To generate a fernet_key :

```
docker run puckel/docker-airflow python -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print(FERNET_KEY)"
```

## Stop Airflow Containers

```
docker-compose down
```

## Configuring Airflow

It's possible to set any configuration value for Airflow from environment variables, which are used over values from the airflow.cfg.

The general rule is the environment variable should be named `AIRFLOW__<section>__<key>`, for example `AIRFLOW__CORE__SQL_ALCHEMY_CONN` sets the `sql_alchemy_conn` config option in the `[core]` section.

Check out the [Airflow documentation](http://airflow.readthedocs.io/en/latest/howto/set-config.html#setting-configuration-options) for more details

You can also define connections via environment variables by prefixing them with `AIRFLOW_CONN_` - for example `AIRFLOW_CONN_POSTGRES_MASTER=postgres://user:password@localhost:5432/master` for a connection called "postgres_master". The value is parsed as a URI. This will work for hooks etc, but won't show up in the "Ad-hoc Query" section unless an (empty) connection is also created in the DB

## Azure Pipeline

[View ADO Pipeline](https://dev.azure.com/AIZ-GT/GT.ICS-Cloud%20Planning/_build?definitionId=1593&_a=summary)

The azure-pipelines.yml file, locaeted in the root of this repo's directory, you'll see the ADO pipeline variables used for deploying to Azure Blob storage for DEV & MODEL.

![ADO Pipeline Variables](./images/ado_pipeline.png)

# COMMON ERRORS

If you encounter this error in the Airflow UI, there could be a variety of reasons causing it one of which has to deal with the __pycache__ directory within the **dags** and **libraries** directories. When we encountered this error in **MODEL** environment the error remained for several minutes and then just went away.

The possible solution for this was to add a line in the *azure-pipelines.yml* to remove __pycache__ so it would remove any corrupted .pyc files. 

More investigation into this error needs to take place as it is only happening in **MODEL**, but not in **DEV**.
```
Broken DAG: [/home/airflow/airflowdags/vdc_dag.py] marshal data too short
```
![ERROR: 'marshal data too short'](./images/marshall_data_too_short.png)