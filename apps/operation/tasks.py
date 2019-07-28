from celery.task import task
from celery import shared_task
from django.core.mail import send_mail
from django.urls import reverse
from django.conf import settings


ACTIVE_EMAIL = '''
<br>
欢迎注册 2ZZY 爱钻研。
<br>
<br>
请点击下面的地址验证你的帐号：
<br>
<br>
<a href="{_url}">{_url}</a>
<br>
<br>
如果你有任何疑问，可以回复这封邮件向我们提问。<br>
<br>
爱钻研(https://www.2zzy.com)</div>
'''


# 自定义要执行的task任务
@task
def print_hello():
    import time
    time.sleep(10)
    return 'hello django'


# @shared_task
def send_email_code(to, code):
    msg = ACTIVE_EMAIL.format(_url=settings.DOMAIN + reverse('activate_email', args=(code,)))
    ret = {'发送状态': '', 'to': '', 'code': '', 'msg': ''}
    try:
        send_mail('[2ZZY] 欢迎来到 爱钻研',
                  '',
                  settings.EMAIL_FROM,
                  [to],
                  html_message=msg)
        ret['发送状态'] = "发送成功"
        ret['to'] = to
        ret['code'] = code
        ret['msg'] = True
    except Exception as e:
        ret['发送状态'] = "失败"
        ret['to'] = to
        ret['code'] = code
        ret['msg'] = e

    return ret
