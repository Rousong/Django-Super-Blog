from django.contrib import admin
from .models import *
# Register your models here.

@admin.register(BodyManage)
class BodyManageAdmin(admin.ModelAdmin):
    list_display = ('user', 'height', 'weight', 'BMI', 'fat_rate')
