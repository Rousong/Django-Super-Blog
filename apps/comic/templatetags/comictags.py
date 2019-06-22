from django.template import Library
from apps.comic.models import Comic

register = Library()

@register.simple_tag
def comic_total_views(comic_id):
    articles = Comic.objects.get(id=comic_id).article.all()
    views = 0
    for article in articles:
        views += article.total_views
    return views

@register.simple_tag
def comic_total_articles(comic_id):
    total_articles = Comic.objects.get(id=comic_id).article.count()
    return total_articles