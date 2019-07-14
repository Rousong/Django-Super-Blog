from django.urls import path

from . import views

app_name = 'comments'
urlpatterns = [
    # 发表一级回复
    path(
        'post-comment/<article_id>/',
        views.CommentCreateView.as_view(),
        name='post_comment'
    ),

    # 发表二级回复
    path(
        'reply-post-comment/<article_id>/<int:node_id>/<article_type>/',
        views.CommentCreateView.as_view(),
        name='reply_post_comment'
    ),
    # # 发表二级回复topic专用
    # path(
    #     'reply-post-comment_topic/<topic_sn>/<int:node_id>/<article_type>/',
    #     views.CommentCreateView.as_view(),
    #     name='reply_post_comment_topic'
    # ),

    # 软删除
    path(
        'soft-delete/',
        views.comment_soft_delete,
        name='soft_delete'
    ),

    # edit
    path(
        'edit/<int:pk>/',
        views.CommentUpdateView.as_view(),
        name='edit'
    ),

    path('count-validate/', views.Comment_count_validate.as_view(), name='count_validate')
]
