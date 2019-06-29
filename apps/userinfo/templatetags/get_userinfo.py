from django import template

from apps.userinfo.models import UserProfile

register = template.Library()

@register.simple_tag
def get_userinfo(id):
    """
    获取UserInfo实例
    :param user_id: User的id
    """
    try:
        userinfo = UserProfile.objects.get(id=id)
    except:
        userinfo = None
    return userinfo