from django.db import models
from django.utils import timezone
from apps.userinfo.models import UserProfile
from django.urls import reverse
from django.contrib.contenttypes.fields import GenericRelation
# 这个是用来在后台显示缩略图用
from django.utils.html import format_html

from apps.comic.models import Comic
from apps.comments.models import Comment

from taggit.managers import TaggableManager
from imagekit.models import ProcessedImageField
from imagekit.processors import ResizeToFit

import markdown
import emoji


# Create your models here.
from db.base_model import BaseModel


class ArticlesColumn(BaseModel):
    """
    article栏目
    """
    title = models.CharField(max_length=100, blank=True, verbose_name='标题')

    class Meta:
        verbose_name_plural = '栏目'

    def __str__(self):
        return self.title


class ArticlesPost(BaseModel):
    """
    博客文章
    """
    author = models.ForeignKey(
        UserProfile,
        related_name='article',
        on_delete=models.CASCADE,
        verbose_name='作者',
    )

    comments = GenericRelation(Comment)

    column = models.ForeignKey(
        ArticlesColumn,
        null=True,
        blank=True,
        on_delete=models.SET_NULL,
        related_name='column',
        verbose_name='栏目',
    )

    title = models.CharField(max_length=200, verbose_name='标题')

    # 漫画中的标题, 若不填则自动填写
    comic_title = models.CharField(
        max_length=200,
        null=True,
        blank=True,
        verbose_name='漫画标题',
    )

    # 漫画外键
    comic = models.ForeignKey(
        Comic,
        related_name='article',
        null=True,
        blank=True,
        on_delete=models.SET_NULL,
        verbose_name='漫画',
    )

    # 博文在漫画中的序号，用于给博文排序
    comic_sequence = models.PositiveIntegerField(
        blank=True,
        null=True,
        verbose_name='漫画序号',
    )

    # taggit
    tags = TaggableManager(blank=True, verbose_name='标签')
    summary = models.CharField('文章摘要', max_length=200,
                               null=True, blank=True,default='显示在文章列表内的摘要,限制在100字内,不支持markdown')
    body = models.TextField(verbose_name='正文')
    total_views = models.PositiveIntegerField(default=0, verbose_name='浏览量')

    # 缩略图
    avatar_thumbnail = ProcessedImageField(
        upload_to='image/article/%Y%m%d',
        processors=[ResizeToFit(width=500)],
        format='JPEG',
        options={'quality': 100},
        blank=True,
        null=True,
        verbose_name='标题图',
    )

    url = models.URLField(blank=True, verbose_name='标题图url')

    class Meta:
        ordering = ('-create_time',)
        verbose_name_plural = '文章'

    def __str__(self):
        return self.title

    def save(self, *args, **kwargs):
        """
        重写save(), 自动填写漫画序号
        """
        if not self.comic_title:
            self.comic_title = self.title

        # 跳过更新日期
        # if not kwargs.pop('skip_updated', False):
        #     self.updated = timezone.now()

        super(ArticlesPost, self).save(*args, **kwargs)

    # 获取文章地址
    def get_absolute_url(self):
        return reverse('article:article_detail', args=[self.id])

    # 获取文章api地址
    def get_api_url(self):
        return reverse('api_article:detail', args=[self.id])

    # 统计浏览量
    def increase_views(self):
        self.total_views += 1
        self.save(update_fields=['total_views'])


# 幻灯片
class Carousel(BaseModel):
    number = models.IntegerField('编号', help_text='编号决定图片播放的顺序，图片不要多于5张')
    title = models.CharField('标题', max_length=20, blank=True, null=True, help_text='标题可以为空')
    content = models.CharField('描述', max_length=80)
    img_url = models.ImageField(upload_to='images/',verbose_name='图片')
    url = models.CharField('跳转链接', max_length=200, default='#', help_text='图片跳转的超链接，默认#表示不跳转')

    def image_data(self):
        return format_html(
            '<img src="{}" width="100px"/>',
            self.img_url.url,
        )
    # short_description为设置标题
    image_data.short_description = u'图片'

    class Meta:
        verbose_name = '图片轮播'
        verbose_name_plural = verbose_name
        # 编号越小越靠前，添加的时间约晚约靠前
        ordering = ['number', '-id']

    def __str__(self):
        return self.content[:25]


# 时间线
class Timeline(BaseModel):
    COLOR_CHOICE = (
        ('primary', '基本-蓝色'),
        ('success', '成功-绿色'),
        ('info', '信息-天蓝色'),
        ('warning', '警告-橙色'),
        ('danger', '危险-红色')
    )
    SIDE_CHOICE = (
        ('L', '左边'),
        ('R', '右边'),
    )
    STAR_NUM = (
        (1, '1颗星'),
        (2, '2颗星'),
        (3, '3颗星'),
        (4, '4颗星'),
        (5, '5颗星'),
    )
    side = models.CharField('位置', max_length=1, choices=SIDE_CHOICE, default='L')
    star_num = models.IntegerField('星星个数', choices=STAR_NUM, default=3)
    icon = models.CharField('图标', max_length=50, default='fa fa-pencil')
    icon_color = models.CharField('图标颜色', max_length=20, choices=COLOR_CHOICE, default='info')
    title = models.CharField('标题', max_length=100)
    content = models.TextField('主要内容')

    class Meta:
        verbose_name = '时间线'
        verbose_name_plural = verbose_name
        ordering = ['update_time']

    def __str__(self):
        return self.title[:20]

    def title_to_emoji(self):
        return emoji.emojize(self.title, use_aliases=True)

    def content_to_markdown(self):
        # 先转换成emoji然后转换成markdown
        to_emoji_content = emoji.emojize(self.content, use_aliases=True)
        return markdown.markdown(to_emoji_content,
                                 extensions=['markdown.extensions.extra', ]
                                 )
