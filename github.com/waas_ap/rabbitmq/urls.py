from django.urls import path
from . import views

app_name = 'rabbitmq'

urlpatterns = [
    path('read_write/', views.read_write, name='read_write_rabbit'),
    path('sent/', views.send_message, name='sent_message'),
    path('get/', views.get_rqm_message, name='get_message'),
]