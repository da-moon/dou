FROM puckel/docker-airflow:1.10.9

ARG GIT_USERNAME
ARG GIT_PASSWORD
USER root
COPY ./scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY setup.cfg .
COPY setup.py .
COPY ./scripts/build.sh .
RUN chmod +x build.sh
RUN chmod +x setup.py
RUN apt-get update -y && apt-get install git -y
RUN apt-get install libssl-dev libcurl4-openssl-dev python-dev -y
USER airflow
RUN echo "Create git netrc" && \
    touch ~/.netrc && \
    echo "machine bitbucket.org" >> ~/.netrc && \
    echo "login ${GIT_USERNAME}" >> ~/.netrc |tee && \
    echo "password ${GIT_PASSWORD}" >> ~/.netrc |tee && \
    mkdir ~/.ssh && echo "ssh-keyscan -H bitbucket.org" >> ~/.ssh/known_hosts
COPY requirements.txt .
RUN PYCURL_SSL_LIBRARY=openssl pip install -r requirements.txt --user
ENTRYPOINT ["/entrypoint.sh"]
