#global.py
from django.conf import settings

def global_setting(request):
    content = {
        'STATIC_URL': settings.STATIC_URL,   #把setting定义的读取出来
        'DOMAIN':settings.DOMAIN,
        'site_end_title': settings.SITE_END_TITLE,
        'site_description': settings.SITE_DESCRIPTION,
        'site_keywords': settings.SITE_KEYWORDS,

    }
    return content