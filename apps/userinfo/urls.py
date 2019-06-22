from django.urls import path

from . import views

app_name = 'userinfo'
urlpatterns = [
    path('mail/', views.UserInfoView.as_view(), name='mail'),
    path('detail/', views.test, name='detail'),
    path('profile/change/', views.change_profile_view,name='change_profile'), # 更新基本资料页面
    path('crop-upload-image/', views.crop_upload_handler, name='crop_upload_image'),
    path('user-signup-validate', views.user_signup_validate, name='user_signup_validate'),
    path('detail/updata/',views.updata_view,name='updata'), # 更新身材信息
]
