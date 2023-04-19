from django.urls import path
from . import views

app_name = 'main'

urlpatterns = [
    path('', views.hello_world, name="helo_world"),
    path('status/', views.hello_world, name="helo_world"),
    path('health/', views.health_check, name="health")
    #path('', views.post_list, name='home'),
    #path('<int:year>/<int:month>/<int:day>/<slug:post>/edit_post', views.edit_post, name='edit_post'),
    #path('<int:year>/<int:month>/<int:day>/<slug:post>/new_post/', views.create_post, name='create_post'),
]