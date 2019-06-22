from django.shortcuts import redirect
from django.views.generic import ListView
from django.http import HttpResponse

from .models import Comic


# Create your views here.
class ComicListView(ListView):
    """
    漫画list
    """
    template_name = 'comic/comic_list.html'
    context_object_name = 'comics'
    model = Comic


def comic_articles_list(request, comic_id):
    """
    漫画中comic_sequence最小的博文
    """
    try:
        article = Comic.objects.get(id=comic_id).article.order_by('comic_sequence')[0]
        return redirect(article)
    except:
        return HttpResponse('还没有任何漫画书')
