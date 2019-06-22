import os
import pymysql
import django_smtp_ssl
import sys
import json

import logging
import django.utils.log
import logging.handlers

pymysql.install_as_MySQLdb()

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# 加入系统的路径,可以不在使用ａｐｐｓ前缀
sys.path.insert(0, os.path.join(BASE_DIR, 'apps'))

# SECURITY WARNING: keep the secret key used in production secret!
# SECRET_KEY = '#!kta!9e0)24d@9#<*=ra$r!0k0+p8@w+a%7g1bbof0+ad@4_('


with open('env.json') as env:
    ENV = json.load(env)

SECRET_KEY = ENV['SECRET_KEY']

if ENV.get('ENV') == 'dev':
    DEBUG = True
else:
    DEBUG = False

# ALLOWED_HOSTS = ['127.0.0.1', 'localhost ', '.2zzy.com']
ALLOWED_HOSTS = ['*']

# log的配置
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            # 'format': '{levelname} {asctime} {module} {process:d} {thread:d} {message}',
            'format': '[{asctime}] [{module}.{funcName}] [{lineno:3}] [{levelname:7}] => {message}',
            'style': '{',
        },
        'simple': {
            'format': '[{levelname}][ {message}]',
            'style': '{',
        },
    },
    'filters': {
        'require_debug_true': {
            '()': 'django.utils.log.RequireDebugTrue',
        },
    },
    'handlers': {
        'console': {
            'level': 'DEBUG',
            'filters': ['require_debug_true'],  # 只有在Django debug为True时才在屏幕打印日志
            'class': 'logging.StreamHandler',
            'formatter': 'verbose'
        },
        'file': {
            'level': 'WARNING',
            'class': 'logging.handlers.TimedRotatingFileHandler',
            'filename': os.path.join(BASE_DIR, 'logs/2zzysite.log'),
            'formatter': 'verbose',
            'when': 'midnight',
            'backupCount': 30,
        },
        'mail_admins': {
            'level': 'ERROR',
            'class': 'django.utils.log.AdminEmailHandler',
        }
    },
    'loggers': {
        'django': {
            'handlers': ['console','file'],
            'level': 'WARNING',
            'propagate': True,
        },
        'django.request': {
            'handlers': ['file','mail_admins'],
            'level': 'ERROR',
            'propagate': False,
        },
       'django.db.backends': {
            'handlers': ['console','file'], # 指定file handler处理器，表示只写入到文件
            'level':'DEBUG',
            'propagate': True,
        },
    },
}

INSTALLED_APPS = [
    # admin增强
    'jet.dashboard',
    'jet',

    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    'rest_framework',
    'corsheaders',

    'crispy_forms',  # bootstrap表单样式

    'apps.userinfo',
    'apps.article',  # 文章
    'apps.comments',  # 评论
    'apps.album',  # 相册
    'apps.comic',  # 漫画
    'apps.readbook',  # 读书
    'apps.imagesource',  # 图库
    'apps.vlog',  # 视频
    'apps.aboutme',  # 作者
    'apps.extends',
    'apps.workout',  # 健身
    'apps.notes',
    'apps.operation',
    'apps.topic',

    'utils',  # 工具

    # django-allauth
    # 必须安装的app
    'django.contrib.sites',
    'allauth',
    'allauth.account',
    'allauth.socialaccount',
    # 下面是第三方账号相关的，选了weibo和github
    'allauth.socialaccount.providers.weibo',
    'allauth.socialaccount.providers.github',

    # 标签
    'taggit',

    # mptt
    'mptt',

    # notifications
    'notifications',
    'mynotifications',

    # haystack search
    'haystack',

    # 富文本编辑器
    'ckeditor',
    # 实现异步发送邮件的模块
    "djcelery_email",

]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'middle.custom_middle.CountOnlineMiddlewareMixin',
    # cor-headers
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',

    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = '2zzy.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'templates')]
        ,
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'conf.global.global_setting'
            ],
        },
    },
]

WSGI_APPLICATION = '2zzy.wsgi.application'


if DEBUG:
    # 开发环境
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.mysql',
            'NAME': 'fittest',
            'USER': 'root',
            'PASSWORD': "",
            'HOST': '127.0.0.1',
            'PORT': '3306',
        }
    }
else:
    # 生产环境
    MYSQL_PASSWORD = ENV.get('MYSQL_KEY')
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.mysql',
            'NAME': '2zzy',
            'USER': '2zzy',
            'PASSWORD': MYSQL_PASSWORD,
            'HOST': '127.0.0.1',
            'PORT': '3306',
        }
    }

# 指定django 的默认使用的认证模型类 要不然迁移的时候会报错
# AUTH_USER_MODEL = 'allauth.User'
AUTH_USER_MODEL = "userinfo.UserProfile"

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


LANGUAGE_CODE = 'zh-hans'

TIME_ZONE = 'Asia/Shanghai'

USE_I18N = True

USE_L10N = True

USE_TZ = True


STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'nginx_static')
STATICFILES_DIRS = (
    os.path.join(BASE_DIR, "static"),
)

MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

# django-allauth相关设置
AUTHENTICATION_BACKENDS = (
    # django admin所使用的用户登录与django-allauth无关
    'django.contrib.auth.backends.ModelBackend',

    # `allauth` specific authentication methods, such as login by e-mail
    'allauth.account.auth_backends.AuthenticationBackend',
)

ACCOUNT_AUTHENTICATION_METHOD = 'username_email'
ACCOUNT_EMAIL_REQUIRED = True
# ACCOUNT_EMAIL_VERIFICATION (="optional")：注册中邮件验证方法:
# “强制（mandatory）”,“可选（optional）”或“否（none）”之一
ACCOUNT_EMAIL_VERIFICATION = 'optional'
SOCIALACCOUNT_EMAIL_VERIFICATION = 'none'

# 设置邮件相关
# EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend' # 这是django默认的邮件后台
# 使用django-celery-email更改默认邮件发送为异步发送
EMAIL_BACKEND ='djcelery_email.backends.CeleryEmailBackend'
EMAIL_HOST = 'smtp.163.com'
EMAIL_HOST_USER = 'do_1024@163.com'
EMAIL_HOST_PASSWORD = ENV.get('EMAIL_HOST_KEY')
EMAIL_PORT = 465
DEFAULT_FROM_EMAIL = 'do_1024@163.com' # 和EMAIL_HOST_USER一样
# EMAIL_USE_TLS = True
EMAIL_USE_SSL = True
EMAIL_FROM = 'do_1024<do_1024@163.com>'
# 设置发送邮件的task任务 这里是django-celery-email的默认配置
CELERY_EMAIL_TASK_CONFIG = {
    'name': 'djcelery_email_send',
    'ignore_result': True,
}

SERVER_EMAIL = 'do_1024@163.com'
ADMINS = (('肉松君', 'beaock@gmail.com'),)

# celery settings
# celer中间人 redis://redis服务所在的ip地址:端口/数据库号
CELERY_BROKER_URL = 'redis://127.0.0.1:6379/0'
# celery结果返回，可用于跟踪结果
CELERY_RESULT_BACKEND = 'redis://127.0.0.1:6379/0'

# celery内容等消息的格式设置
CELERY_ACCEPT_CONTENT = ['application/json', ]
CELERY_TASK_SERIALIZER = 'json'
CELERY_RESULT_SERIALIZER = 'json'

# celery时区设置，使用settings中TIME_ZONE同样的时区
CELERY_TIMEZONE = TIME_ZONE

LOGIN_REDIRECT_URL = '/'
SITE_ID = 2


# 使用django-redis缓存页面，缓存配置如下：
CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://127.0.0.1:6379/1",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        }
    },
    # 新增配置让session 使用，
    "session": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://127.0.0.1:6379/0",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        }
    }
}


# haystack相关配置
HAYSTACK_CONNECTIONS = {
    'default': {
        'ENGINE': 'article.whoosh_cn_backend.WhooshEngine',
        'PATH': os.path.join(BASE_DIR, 'whoosh_index'),
    },
}
HAYSTACK_SEARCH_RESULTS_PER_PAGE = 20
HAYSTACK_SIGNAL_PROCESSOR = 'haystack.signals.RealtimeSignalProcessor'


REST_FRAMEWORK = {
    'DEFAULT_RENDERER_CLASSES': (
        'rest_framework.renderers.JSONRenderer',
    ),
    'DEFAULT_PARSER_CLASSES': (
        'rest_framework.parsers.JSONParser',
    )
}

CORS_ORIGIN_ALLOW_ALL = True
# ckeditor
CKEDITOR_CONFIGS = {
    # django-ckeditor默认使用配置
    'default': {
        'language': 'zh-hans',
        'width': 'auto',
        'height': '250px',
        'tabSpaces': 4,
        'toolbar': 'Custom',
        'toolbar_Custom': [
            ['Smiley', 'CodeSnippet', '-', 'Bold', 'Italic', 'Underline', 'RemoveFormat', ],
            ['NumberedList', 'BulletedList'],
            ['TextColor', 'BGColor'],
            ['Link', 'Unlink'],
            ['Undo', 'Redo', 'Marker'],
            ['Maximize']
        ],
        # 插件
        'extraPlugins': ','.join(['codesnippet', 'prism', 'widget', 'lineutils', ]),
    }
}


# 网站默认设置和上下文信息
SITE_END_TITLE = '钻研各种技术领域'
SITE_DESCRIPTION = '钻研各种技术领域'
SITE_KEYWORDS = '健身,养生,教程,塑性,肌肉,编程,代码,漫画'
#DOMAIN = 'http://127.0.0.1:8000'
DOMAIN = 'http://www.2zzy.com'

# 表单插件的配置
CRISPY_TEMPLATE_PACK = 'bootstrap4'


# 分页器配置
PRE_PAGE_COUNT = 15
PAGER_NUMS = 7

# 头像存放目录（当然也可以使用OSS等云存储，这里存储到本地）
AVATAR_FILE_PATH = os.path.join(BASE_DIR, 'static', 'img')

# session 相关配置
SESSION_ENGINE = "django.contrib.sessions.backends.cache"
SESSION_CACHE_ALIAS = "session"
SESSION_COOKIE_NAME = "sessionid"
SESSION_COOKIE_PATH = "/"
SESSION_COOKIE_AGE = 60 * 20
# 用户刷新页面，重新设置缓存时间
SESSION_SAVE_EVERY_REQUEST = True