from django.contrib import admin
from django.urls import path, include
from django.conf.urls import url
from django.views.generic import TemplateView
from django.conf import settings
from django.conf.urls.static import static
from utils import check_code

from apps.article.views import ArticlePostView,TimelineView
from apps.article.feeds import ArticlesPostRssFeed, ArticlesPostColumnRssFeed

import notifications.urls

from apps.operation.views import TopicVoteView, FavoriteTopicView, FavoriteNodeView, ThanksTopicView, BalanceView, \
    DailyMissionView, SettingView, AvatarSettingView, PhoneSettingView, EmailSettingView, PasswordSettingView, \
    SendActivateCodeView, ActivateEmailView, FollowingView, BlockView, DailyRandomBalanceView
from apps.topic.views import RecentView, NewTopicView, NodeView, NodeLinkView, TopicView, MarkdownPreView, \
    MyFollowingView, MyFavoriteNodeView, MyFavoriteTopicView
from apps.userinfo.views import MemberView, SigninView, SignupView, SignoutView
from utils import check_code

urlpatterns = [
    url(r'^jet/', include('jet.urls', 'jet')),
    url(r'^jet/dashboard/', include('jet.dashboard.urls', 'jet-dashboard')),

    path('admin/', admin.site.urls),
    url(r'^$', ArticlePostView.as_view(), name='home'),
    path('admiration/', TemplateView.as_view(template_name='utils/admiration.html'), name='admiration'),

    path('userinfo/', include('apps.userinfo.urls', namespace='userinfo')),

    path('article/', include('apps.article.urls', namespace='article')),
    url(r'comments/', include('apps.comments.urls', namespace='comments')),
    path('album/', include('apps.album.urls', namespace='album')),
    path('comic/', include('apps.comic.urls', namespace='comic')),

    path('book/', include('apps.readbook.urls', namespace='readbook')),

    path('imagesource/', include('apps.imagesource.urls', namespace='imagesource')),

    path('vlog/', include('apps.vlog.urls', namespace='vlog')),

    path('aboutme/', include('apps.aboutme.urls', namespace='aboutme')),

    path('my-notifications/', include('apps.mynotifications.urls', namespace='my_notifications')),
    url(r'^timeline/$', TimelineView.as_view(), name='timeline'),  # timeline页面
    url(r'^tool/', include('workout.urls',namespace='workout')), # 运动工具

    # RSS订阅
    url(r'^all/rss/$', ArticlesPostRssFeed(), name='rss'),
    path('all/rss/<int:column_id>/', ArticlesPostColumnRssFeed(), name='column_rss'),

    # haystack search
    url(r'^search/', include('haystack.urls')),

    # allauth
    path('accounts/', include('allauth.urls')),

    path('account/weibo_login_success/', TemplateView.as_view(template_name='account/weibo_login_success.html')),

    # notifications
    url('^inbox/notifications/', include(notifications.urls, namespace='notifications')),

    # extends
    path('extends/', include('apps.extends.urls', namespace='extends')),

    # rest-framework login view
    url(r'^api/auth/', include('rest_framework.urls')),

    # api-article
    path('api/article/', include('apps.article.api.urls', namespace='api_article')),

    # api-comments
    path('api/comments/', include('apps.comments.api.urls', namespace='api_comments')),


path('recent', RecentView.as_view(), name='recent'),
    # 发布新主题
    path('new', NewTopicView.as_view(), name='new'),
    # notes
    # path('n', NewTopicView.as_view(), name='new'),
    # 查看某个用户信息
    path('member/<slug:username>', MemberView.as_view(), name='member'),
    # 到某个节点下的主题
    path('go/<slug:node_code>', NodeView.as_view(), name='node'),
    # 到某个节点下的实用节点链接
    path('go/<slug:node_code>/links', NodeLinkView.as_view(), name='node_link'),
    # 主题查看
    path('t/<slug:topic_sn>', TopicView.as_view(), name='topic'),
    # 主题投票
    path('topic/vote', TopicVoteView.as_view(), name='topic_vote'),
    # 主题收藏
    path('topic/favorite', FavoriteTopicView.as_view(), name='favorite_topic'),
    # 主题感谢
    path('topic/thanks', ThanksTopicView.as_view(), name='thanks_topic'),
    # 节点收藏
    path('node/favorite', FavoriteNodeView.as_view(), name='favorite_node'),
    # 用户注册
    path('signup', SignupView.as_view(), name='signup'),
    # 用户登录
    path('signin', SigninView.as_view(), name='signin'),
    # 用户退出
    path('signout', SignoutView.as_view(), name='signout'),
    # 用户设置
    path('settings', SettingView.as_view(), name='settings'),
    # 用户头像设置
    path('settings/avatar', AvatarSettingView.as_view(), name='settings_avatar'),
    # 用户手机设置
    path('settings/phone', PhoneSettingView.as_view(), name='settings_phone'),
    # 用户Email设置
    path('settings/email', EmailSettingView.as_view(), name='settings_email'),
    # 密码修改
    path('settings/password', PasswordSettingView.as_view(), name='settings_password'),
    # 发送随机码地址
    path('activate', SendActivateCodeView.as_view(), name='activate'),
    # 用户邮箱激活链接
    path('activate/<slug:code>', ActivateEmailView.as_view(), name='activate_email'),
    # Following 动作
    path('following/<slug:username>', FollowingView.as_view(), name='following'),
    # Block 动作
    path('block/<slug:username>', BlockView.as_view(), name='block'),
    # 我收藏的节点
    path('my/nodes', MyFavoriteNodeView.as_view(), name='my_nodes'),
    # 我收藏的主题
    path('my/topics', MyFavoriteTopicView.as_view(), name='my_topics'),
    # 我关注的人的信息
    path('my/following', MyFollowingView.as_view(), name='my_following'),
    # 生成图形验证码
    # path('check_code', check_code, name='check_code'),
    # 发帖时markdown 格式预览
    path('preview/markdown', MarkdownPreView.as_view(), name='markdown_preview'),
    # 每日金币奖励
    path('mission/daily', DailyMissionView.as_view(), name='daily_mission'),
    # 随机生成金钱接口
    path('mission/daily/redeem', DailyRandomBalanceView.as_view(), name='daily_random_balance'),
    # 用户金钱
    path('balance', BalanceView.as_view(), name='balance'),

]
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
