from django.db import models
from django.utils import timezone

from db.base_model import BaseModel


class SiteMessage(BaseModel):
    """通知小贴条"""
    content = models.TextField(verbose_name="正文")

    class Meta:
        verbose_name_plural = '通知'

    def __str__(self):
        return self.content[:20]
