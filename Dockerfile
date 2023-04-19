FROM python:3.8.3-buster

LABEL maintainer="Fernando Silva"

ARG WAAS_HOME=/usr/local/waas_api
ENV DJANGO_SUPERUSER_USERNAME='admin'
ENV DJANGO_SUPERUSER_PASSWORD='admin'
ENV DJANGO_SUPERUSER_EMAIL='myemail@digitalonus.com'
WORKDIR ${WAAS_HOME}

COPY . ${WAAS_HOME}

RUN apt update && \
    apt-get -y install python3-pip && \
    python3 -m pip install --upgrade pip && \
    pip3 install psycopg2-binary && \
    pip3 install -r requirements.txt

EXPOSE 8000

CMD python3 manage.py collectstatic --noinput && \
    python3 manage.py makemigrations --noinput && \
    python3 manage.py migrate --noinput && \
    python3 manage.py loaddata sample_data.yaml && \
    python3 manage.py search_index --rebuild -f && \
    python manage.py create_admin_user \
        --user=$DJANGO_SUPERUSER_USERNAME \
        --password=$DJANGO_SUPERUSER_PASSWORD \
        --email=$DJANGO_SUPERUSER_EMAIL && \
    python3 manage.py runserver 0.0.0.0:8000 && \
    python manage.py create_admin_user \
        --user=$DJANGO_SUPERUSER_USERNAME \
        --password=$DJANGO_SUPERUSER_PASSWORD \
        --email=$DJANGO_SUPERUSER_EMAIL && \
        python3 manage.py runserver 0.0.0.0:8000