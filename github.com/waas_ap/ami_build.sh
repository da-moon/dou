FROM python:3.8.3-buster

#ENV DJANGO_SUPERUSER_USERNAME='admin'
#ENV DJANGO_SUPERUSER_PASSWORD='admin'
#ENV DJANGO_SUPERUSER_EMAIL='myemail@digitalonus.com'
mkdir /opt/waas
cp
COPY . .

RUN apt update && \
    apt-get -y install python3-pip && \
    python3 -m pip install --upgrade pip && \
    pip3 install psycopg2-binary && \
    pip3 install -r requirements.txt

EXPOSE 8000

CMD python3 manage.py collectstatic --noinput && \
    python3 migrate.py && \
    # python manage.py create_admin_user \
    #         --user=$DJANGO_SUPERUSER_USERNAME \
    #         --password=$DJANGO_SUPERUSER_PASSWORD \
    #         --email=$DJANGO_SUPERUSER_EMAIL && \
# python3 manage.py makemigrations --noinput && \
#    python3 manage.py migrate --noinput && \
 #   python3 manage.py loaddata employees_data.yaml  && \
 #   python3 manage.py search_index --rebuild -f && \
    python3 manage.py runserver 0.0.0.0:8000
