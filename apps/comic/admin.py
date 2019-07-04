from django.contrib import admin

from .models import Comic, GithubRepo


class ComicAdmin(admin.ModelAdmin):
    list_display = ('title', 'id', 'create_time')
    ordering = ('id',)


admin.site.register(Comic, ComicAdmin)
admin.site.register(GithubRepo)
