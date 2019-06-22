from django.urls import path
from . import views

app_name = 'extends'
urlpatterns = [
    path('latest-site-message', views.latest_site_message, name='site_message')
]
