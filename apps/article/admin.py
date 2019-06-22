from django.contrib import admin
from .models import ArticlesPost, ArticlesColumn,Carousel,Timeline

# 自定义管理站点的名称和URL标题
admin.site.site_header = '网站管理'
admin.site.site_title = '博客后台管理'

# Register your models here.
class ArticlesPostAdmin(admin.ModelAdmin):
    list_display = ('title', 'comic_id', 'comic_sequence', 'total_views')
    list_filter = ('comic_id', 'column_id')

admin.site.register(ArticlesPost, ArticlesPostAdmin)
admin.site.register(ArticlesColumn)

@admin.register(Carousel)
class CarouselAdmin(admin.ModelAdmin):
    list_display = ('number', 'title', 'content', 'img_url', 'url','image_data')
    # 可以在后台显示出图片缩略图
    # readonly_fields为设置该列不可编辑
    readonly_fields = ('image_data',)


@admin.register(Timeline)
class TimelineAdmin(admin.ModelAdmin):
    list_display = ('title', 'side', 'update_date', 'icon', 'icon_color',)
    fieldsets = (
        ('图标信息', {'fields': (('icon', 'icon_color'),)}),
        ('时间位置', {'fields': (('side', 'update_date', 'star_num'),)}),
        ('主要内容', {'fields': ('title', 'content')}),
    )
    date_hierarchy = 'update_date'
    list_filter = ('star_num', 'update_date')

