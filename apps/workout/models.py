from django.db import models
from django.conf import settings
from db.base_model import BaseModel
from apps.userinfo.models import UserProfile
from django.dispatch import receiver
from django.db.models.signals import post_save

class BodyManage(BaseModel):
    zt_choices = (
        (0, '保持体型'),
        (1, '增肌'),
        (2, '减脂'),
        (3, '增重'),
        (4, '增强心肺'),
        (5, '改善体态')
    )

    user = models.ForeignKey(UserProfile,on_delete=models.CASCADE, verbose_name='所属用户')
    # Decimal 实例表示固定精度的十进制数的字段。它有两个必须的参数：max_digits：数字允许的最大位数 decimal_places：小数的最大位数
    height = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='身高')
    weightMb = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='目标体重')
    weight = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='体重')
    BMI = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='BMI(kg/m²)')
    fat_rate = models.DecimalField(max_digits=4, decimal_places=2, null=True, blank=True, verbose_name='体脂率(%)')
    fat_rateMb = models.DecimalField(max_digits=4, decimal_places=2, null=True, blank=True, verbose_name='目标体脂率(%)')
    xiongwei = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='胸围(cm)')
    biwei = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='臂围(cm)')
    jiankaun = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='肩宽(cm)')
    yaowei = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='腰围(cm)')
    tunwei = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='臀围(cm)')
    datuiwei = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='腿围(cm)')
    jiaohuai = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='脚踝(cm)')
    shouwan = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='手腕(cm)')
    bowei = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='脖围(cm)')
    jiaochang = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='脚长(cm)')
    BMR = models.DecimalField(max_digits=4, decimal_places=0, null=True, blank=True, verbose_name='基础代谢(kcal)')
    TDEE = models.DecimalField(max_digits=4, decimal_places=0, null=True, blank=True, verbose_name='每日热量总消耗(kcal)')
    zt = models.SmallIntegerField(default=0, choices=zt_choices, verbose_name='当前状态')

    class Meta:
        db_table = 'body_bodymanage'
        verbose_name = '身材记录管理'
        verbose_name_plural = verbose_name


class WeightManage(BaseModel):
    user = models.ForeignKey(UserProfile,on_delete=models.CASCADE, verbose_name='所属用户')
    # Decimal 实例表示固定精度的十进制数的字段。它有两个必须的参数：max_digits：数字允许的最大位数 decimal_places：小数的最大位数
    rm = models.DecimalField(max_digits=4, decimal_places=2, null=True, blank=True, verbose_name='rm')
    wotui = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='卧推')
    shendun = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='深蹲')
    yingla = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True, verbose_name='硬拉')

    class Meta:
        db_table = 'body_weightmanage'
        verbose_name = '配重记录管理'
        verbose_name_plural = verbose_name

@receiver(post_save, sender=UserProfile)
def create_user_workout_profile(sender, instance, created, **kwargs):
    if created:
        BodyManage.objects.create(user=instance)
        WeightManage.objects.create(user=instance)
