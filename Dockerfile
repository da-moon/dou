FROM puckel/docker-airflow:1.10.4
LABEL maintainer="Sangeetha Gajam"

ARG AIRFLOW_USER_HOME=/usr/local/airflow

USER root
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN mkdir -p -m 0600 ~/.ssh 
RUN ssh-keyscan -H gitlab.com >> ~/.ssh/known_hosts

RUN pip uninstall fewknow_airflow
RUN pip install jira
RUN pip install slack
RUN pip install msrest
RUN pip install azure-devops

RUN --mount=type=ssh,id=gitlab_ssh_key pip install git+ssh://git@gitlab.com/DigitalOnUs/singularity/airflow/airflow-custom-operators.git@geetha
RUN mkdir /usr/local/airflow/logs/
RUN chmod u=rwx,g=rwx,o=rwx /usr/local/airflow/logs/

USER airflow
WORKDIR ${AIRFLOW_USER_HOME}
CMD ["webserver"]
