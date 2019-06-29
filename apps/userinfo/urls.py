from django.urls import path

from . import views

app_name = 'userinfo'
urlpatterns = [
    path('mail/', views.UserInfoView.as_view(), name='mail'),
    # path('detail/', views.test, name='detail'),
    path('detail/', views.ProfileView.as_view(), name='detail'),
    path('profile/change/', views.Change_profile.as_view(),name='change_profile'), # 更新基本资料页面
    path('crop-upload-image/', views.Crop_upload_handler.as_view(), name='crop_upload_image'),
    path('user-signup-validate', views.user_signup_validate, name='user_signup_validate'),
    path('detail/updata/',views.updata_view,name='updata'), # 更新身材信息
]
