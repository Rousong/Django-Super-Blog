from django.db import models
from django.utils import timezone
from apps.userinfo.models import UserProfile
from django.urls import reverse
from django.contrib.contenttypes.fields import GenericRelation

from apps.comments.models import Comment
from db.base_model import BaseModel


class Vlog(BaseModel):
    """
    vlog model
    """
    author = models.ForeignKey(
        UserProfile,
        related_name='vlog',
        on_delete=models.CASCADE,
        verbose_name='作者',
    )

    comments = GenericRelation(Comment)


    title = models.CharField(max_length=200, verbose_name='标题')
    # 简介正文
    body = models.TextField(
        blank=True,
        verbose_name='正文',
    )
    # 缩略图 url
    avatar_url = models.URLField(verbose_name='标题图链接')
    # video url
    video_url = models.URLField(null=True, blank=True,verbose_name='视频链接')
    # 嵌入代码
    iframe = models.CharField(max_length=400,null=True, blank=True,verbose_name='嵌入代码')

    total_views = models.PositiveIntegerField(default=0, verbose_name='浏览量')

    class Meta:
        ordering = ('-create_time',)
        verbose_name_plural = '视频'

    def __str__(self):
        return self.title

    # 获取vlog detail地址
    def get_absolute_url(self):
        return reverse('vlog:detail', args=[self.id])

    # 统计浏览量
    def increase_views(self):
        self.total_views += 1
        self.save(update_fields=['total_views'])
