from django.urls import path
from . import views

app_name = 'els'

urlpatterns = [
    path('new_person/', views.add_person, name='add_new_person'),
    path('persons_list/', views.post_list, name='persons_list'),
    path('person_search/', views.person_search, name='person_search'),
    path('read_write_db/', views.write_number_db, name='readwrite'),
    path('read_write_db/<int:add>', views.write_number_db, name='readwrite'),
    path('write_write_db/', views.read_number_db, name='read')
]