from django.urls import path
from django.conf.urls import url

from . import views

app_name = 'comic'
urlpatterns = [
    path(
        '',
        views.ComicListView.as_view(),
        name='comic_list',
    ),
    url(
        r'^articles-list/(?P<comic_id>\d+)/$',
        views.comic_articles_list,
        name='comic_articles_list',
    ),
]

