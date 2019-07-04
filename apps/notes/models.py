from datetime import datetime
from django.db import models
from apps.userinfo.models import UserProfile
from django.contrib.auth import get_user_model

from db.base_model import BaseModel

User = get_user_model()


# Create your models here.


class NotesFolder(BaseModel):
    """
    Notes 目录
    """
    title = models.CharField(default="", max_length=30, verbose_name="文件夹标题", help_text="文件夹标题")
    url = models.CharField(default="", max_length=30, unique=True, verbose_name="文件夹URL", help_text="文件夹URL")
    desc = models.TextField(null=True, blank=True, verbose_name="文件夹名称描述", help_text="文件夹名称描述")

    class Meta:
        verbose_name = "Notes 目录"
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.title


class Notes(BaseModel):
    """
    Notes
    """
    NOTE_TYPE = (
        (0, "Default"),
        (1, "Markdown"),
    )

    folder = models.ForeignKey(NotesFolder, verbose_name="所在目录", default=1, on_delete=models.CASCADE)
    author = models.ForeignKey(User, verbose_name="Note作者", on_delete=models.CASCADE)
    notes_sn = models.CharField(max_length=20, unique=True, verbose_name="Note唯一sn")
    content = models.TextField(max_length=200000, null=True, blank=True, verbose_name="Note正文")
    notes_type = models.IntegerField(choices=NOTE_TYPE, verbose_name="Note正文类型", help_text="Note正文类型")

    class Meta:
        verbose_name = 'Notes'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.notes_sn
