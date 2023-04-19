from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect, JsonResponse, HttpResponseForbidden
import pika
from HelloWorld import utils
from HelloWorld import settings
import os


def read_write(request):
    return render(request, 'rabbitmq/send_get_message.html', {})


def set_rqm_connection():
    print(utils.get_consul_value('RABBITMQ_USER'),
          utils.get_vault_secret(settings.VAULT_CLIENT, 'RABBITMQ_PASSWORD', os.getenv("KEYS_DIR", "django_secrets")))
    credentials = pika.PlainCredentials(utils.get_consul_value('RABBITMQ_USER'), utils.get_vault_secret(
        settings.VAULT_CLIENT, 'RABBITMQ_PASSWORD', os.getenv("KEYS_DIR", "django_secrets")))
    host = 'rabbit'  # if settings.FOR_CONTAINER else '127.0.0.1'
    return pika.BlockingConnection(pika.ConnectionParameters(host, 5672, '/vhost', credentials))


def send_message(request):
    connection = set_rqm_connection()
    channel = connection.channel()

    channel.queue_declare(queue='hello')
    channel.basic_publish(
        exchange='', routing_key='hello', body='Hello World!!!')
    print(" [x] Sent 'Hello World!!!!'")
    connection.close()
    resp = {
        's': 0,
        'm': 'success'
    }
    return JsonResponse(resp)


def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)


def get_rqm_message(request):
    connection = set_rqm_connection()
    channel = connection.channel()
    channel.queue_declare(queue='hello')
    channel.basic_consume(
        queue='hello', on_message_callback=callback, auto_ack=True)
    print(' [*] Waiting for messages. To exit press CTRL+C')
    channel.start_consuming()
    resp = {
        's': 0,
        'm': 'success'
    }
    return JsonResponse(resp)
