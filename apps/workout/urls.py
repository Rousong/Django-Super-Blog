from django.urls import path
from apps.workout.views import *

app_name = 'workout'

urlpatterns = [
    path('', toolview, name='tool'),
    path('tdee', tdeeview, name='tdee'),  # tdee计算器
    path('alcohol', alcoholview, name='alcohol'),  # alcohol
    path('1rm', oneRmview, name='1rm'),  # 1rm
    path('cal', calview, name='cal'),  # cal
    path('mhr', mhrview, name='mhr'),  # mhr
    path('macro', macroview, name='macro'),  # macro
]