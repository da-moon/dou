FROM python:3.7.4


WORKDIR /usr/src/concourse

ARG GIT_USERNAME
ARG GIT_PASSWORD
USER root
RUN apt-get update -y && apt-get install git -y
RUN echo "Create git netrc" && \
    touch ~/.netrc && \
    echo "machine bitbucket.org" >> ~/.netrc && \
    echo "login ${GIT_USERNAME}" >> ~/.netrc |tee && \
    echo "password ${GIT_PASSWORD}" >> ~/.netrc |tee && \
    mkdir ~/.ssh && echo "ssh-keyscan -H bitbucket.org" >> ~/.ssh/known_hosts
COPY . .
RUN pip install -r requirements.txt --user

CMD [ "python", "enterprise_scheduler_job.py" ]
