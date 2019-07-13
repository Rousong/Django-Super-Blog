from allauth.account.utils import sync_user_email_addresses
from allauth.socialaccount.models import SocialAccount
from django.contrib.auth import get_user_model
from django.dispatch import receiver
from django.urls import reverse_lazy
from django.contrib.auth.decorators import login_required
from django.shortcuts import render,redirect
from django.http import JsonResponse, HttpResponse, Http404
from django.contrib.auth.hashers import check_password
from django.utils.decorators import method_decorator
from django.views.generic import View
from django.urls import reverse
from datetime import datetime
from django.db.models import Q
from io import BytesIO
from utils.check_code import create_validate_code
from utils.auth_decorator import login_auth
from django.contrib.auth import login,authenticate
from allauth.account.signals import user_logged_in
from django.utils import timezone


from apps.topic.models import Topic
from .forms import PhotoForm
from .models import UserProfile, get_default_avatar_url, UserFollowing
from apps.workout.models import BodyManage
from .forms import UserInfoForm,BodyForm
from .forms import SignupForm, SigninForm
from apps.operation.models import UserDetails, SignedInfo, FavoriteNode, TopicVote
from django.core.cache import cache

from allauth.account.views import EmailView,LoginView
from braces.views import LoginRequiredMixin

from allauth.account.models import EmailAddress
from django.contrib import messages

User = get_user_model()

def check_code(request):
    """
    验证码
    :param request:
    :return:
    """
    stream = BytesIO()
    img, code = create_validate_code()
    img.save(stream, 'PNG')
    request.session['CheckCode'] = code
    return HttpResponse(stream.getvalue())

def user_signup_validate(request):
    """登录/注册验证"""
    data = request.POST
    on_validate_type = data.get('type')

    # signup
    if on_validate_type == 'username':
        if UserProfile.objects.filter(username__iexact=data.get('username')).exists():
            return HttpResponse('403')
    elif on_validate_type == 'email':
        if EmailAddress.objects.filter(email__iexact=data.get('email')).exists():
            return HttpResponse('403')

    # login
    elif on_validate_type == 'login':
        password = data.get('password')

        if UserProfile.objects.filter(username__iexact=data.get('login')).exists():
            user = UserProfile.objects.get(username__iexact=data.get('login'))
            if check_password(password, user.password):
                return HttpResponse('200')
            else:
                return HttpResponse('403')

        elif EmailAddress.objects.filter(email__iexact=data.get('login')).exists():
            user = EmailAddress.objects.get(email__iexact=data.get('login')).user
            if check_password(password, user.password):
                return HttpResponse('200')
            else:
                return HttpResponse('403')

        else:
            return HttpResponse('403')

    return HttpResponse('200')


class UserIn222foView(EmailView):
    """
    展示个人信息
    """
    @method_decorator(login_auth)
    def dispatch(self, request, *args, **kwargs):
        # user=User.objects.filter(id=self.request.session.get('user_info')['uid']).first()
        sync_user_email_addresses(request.user)
        return super(UserInfoView, self).dispatch(request, *args, **kwargs)

    success_url = reverse_lazy('userinfo:detail')
    login_url = "/accounts/login"


    # def get_context_data(self, **kwargs):
    #     """
    #     添加或新建userinfo上下文
    #     """
    #     context = super(UserInfoView, self).get_context_data(**kwargs)
    #     # id = self.request.user.id
    #
    #     try:u
    #     #         userinfo = User.objects.filter(id=self.request.session.get('user_info')['id']).first()
    #
    #     except:
    #         userinfo = UserProfile.objects.create(id=id)
    #
    #     if not userinfo.avatar:
    #         userinfo.avatar = get_default_avatar_url()
    #         userinfo.save()
    #
    #     userinfo_form = UserInfoForm()
    #     data = {
    #         'userinfo': userinfo,
    #         'userinfo_form': userinfo_form,
    #     }
    #     context.update(data)
    #
    #     return context

# class UserInfoView(EmailView):
#     """
#     展示个人信息
#     """
#
#     @method_decorator(login_auth)
#     def dispatch(self, request, *args, **kwargs):
#         sync_user_email_addresses(request.user)
#         request.user=User.objects.filter(id=request.session.get('user_info')['uid']).first()
#         return super(UserInfoView, self).dispatch(request, *args, **kwargs)
#
#     success_url = reverse_lazy('userinfo:detail')
#     login_url = "/accounts/login"
#
#
#     def get_context_data(self, **kwargs):
#         """
#         添加或新建userinfo上下文
#         """
#
#         context = super(UserInfoView, self).get_context_data(**kwargs)
#         user_id = self.request.user.id
#
#         try:
#             userinfo = User.objects.get(user_id=user_id)
#
#         except:
#             userinfo = User.objects.create(user_id=user_id)
#
#         if not userinfo.avatar:
#             userinfo.avatar = get_default_avatar_url()
#             userinfo.save()
#
#         userinfo_form = UserInfoForm()
#         data = {
#             'userinfo': userinfo,
#             'userinfo_form': userinfo_form,
#         }
#         context.update(data)
#
#         return context

class UserInfoView(EmailView):
    """
    展示个人信息
    """
    success_url = reverse_lazy('userinfo:detail')
    login_url = "/accounts/login"

    def get_context_data(self, **kwargs):
        """
        添加或新建userinfo上下文
        """
        context = super(UserInfoView, self).get_context_data(**kwargs)
        user_id = self.request.user.id

        try:
            userinfo = UserProfile.objects.get(user_id=user_id)

        except:
            userinfo = UserProfile.objects.create(user_id=user_id)

        if not userinfo.avatar:
            userinfo.avatar = get_default_avatar_url()
            userinfo.save()

        userinfo_form = UserInfoForm()
        data = {
            'userinfo': userinfo,
            'userinfo_form': userinfo_form,
        }
        context.update(data)

        return context

class ProfileView(View):
    @method_decorator(login_auth)
    def dispatch(self, request, *args, **kwargs):
        return super(ProfileView, self).dispatch(request, *args, **kwargs)

    def get(self, request):

        user = User.objects.filter(id=request.session.get('user_info')['uid']).first()

        # print(user)
        # if not user.avatar:
        #     user.avatar = get_default_avatar_url()
        #     user.save()


        form = UserInfoForm(instance=user)
        user_body_info = BodyManage.objects.get(user=user)
        body_form = BodyForm(instance=user_body_info)
        return render(request, 'account/profile.html',
                      context={'form': form, 'userinfo': user, 'body_form': body_form,'user':user})


@login_required
def test(request):

    user_id = request.user.id

    try:
        userinfo = UserProfile.objects.get(user_id=user_id)

    except:
        userinfo = UserProfile.objects.create(user_id=user_id)

    if not userinfo.avatar:
        userinfo.avatar = get_default_avatar_url()
        userinfo.save()

    # 获取用户的默认收货地址
    # try:
    #     details = BodyManage.objects.get(user=request.user)
    # except BodyManage.DoesNotExist:
    #     details = BodyManage.objects.create(user=request.user)
    #
    # details = BodyManage.objects.get(user=request.user)
    # detailForm = DetailForm(instance=details)
    form = UserInfoForm(instance=userinfo)
    user_body_info = BodyManage.objects.get(user=request.user)
    body_form = BodyForm(instance=user_body_info)
    return render(request,'account/profile.html',context={'form':form,'userinfo': userinfo,'body_form':body_form})





class Crop_upload_handler(View):
    @method_decorator(login_auth)
    def dispatch(self, request, *args, **kwargs):
        return super(Crop_upload_handler, self).dispatch(request, *args, **kwargs)

    def post(self, request):
        form = PhotoForm(request.POST, request.FILES)
        if form.is_valid():
            # user_id = request.user.id
            id = request.session.get('user_info')['uid']
            form.save(id=id)
            user=User.objects.filter(id=self.request.session.get('user_info')['uid']).first()
            # 上传新头像之后更新缓存中的头像地址
            request.session['user_info']['avatar'] = user.avatar.url

        return redirect('userinfo:detail')


# @login_required(login_url='/accounts/login')
# def crop_upload_handler(request):
#     """
#     裁剪并上传用户头像
#     """
#     if request.method == 'POST':
#         form = PhotoForm(request.POST, request.FILES)
#         if form.is_valid():
#             user_id = request.user.id
#             form.save(user_id=user_id)
#     return redirect('userinfo:detail')

@login_required
def updata_view(request):
    if request.method == 'POST':
        user_id = request.user.id
        userinfo = UserProfile.objects.get(user_id=user_id)
        user_body_info = BodyManage.objects.get(user=request.user)
        # 更新哪一个表单就一定要有  request.POST这个参数!!!
        body_form = BodyForm(request.POST,instance=user_body_info)
        form = UserInfoForm(instance=userinfo)
        if body_form.is_valid():
            body_form.save()
            # 添加一条信息,表单验证成功就重定向到个人信息页面
            messages.add_message(request,messages.SUCCESS,'身体数据更新成功！')
            return redirect('userinfo:detail')
        else:
            return render(request, 'account/profile.html', context={'body_form': body_form,'form':form,})

    # return render(request,'oauth/profile.html',context={'detailForm':detailForm,'form':form})

class Update_bodyDate(View):
    @method_decorator(login_auth)
    def dispatch(self, request, *args, **kwargs):
        return super(Update_bodyDate, self).dispatch(request, *args, **kwargs)

    def post(self,request):
        user = User.objects.filter(id=request.session.get('user_info')['uid']).first()
        # user_id = request.user.id
        # userinfo = UserProfile.objects.get(user_id=user_id)
        user_body_info = BodyManage.objects.get(user=user)
        # 更新哪一个表单就一定要有  request.POST这个参数!!!
        body_form = BodyForm(request.POST, instance=user_body_info)
        form = UserInfoForm(instance=user)
        if body_form.is_valid():
            body_form.save()
            # 添加一条信息,表单验证成功就重定向到个人信息页面
            messages.add_message(request, messages.SUCCESS, '身体数据更新成功！')
            return redirect('userinfo:detail')
        else:
            return render(request, 'account/profile.html', context={'body_form': body_form, 'form': form, })


def updata_view(request):
    if request.method == 'POST':
        user = User.objects.filter(id=request.session.get('user_info')['uid']).first()
        user_id = request.user.id
        userinfo = UserProfile.objects.get(user_id=user_id)
        user_body_info = BodyManage.objects.get(user=request.user)
        # 更新哪一个表单就一定要有  request.POST这个参数!!!
        body_form = BodyForm(request.POST,instance=user_body_info)
        form = UserInfoForm(instance=userinfo)
        if body_form.is_valid():
            body_form.save()
            # 添加一条信息,表单验证成功就重定向到个人信息页面
            messages.add_message(request,messages.SUCCESS,'身体数据更新成功！')
            return redirect('userinfo:detail')
        else:
            return render(request, 'account/profile.html', context={'body_form': body_form,'form':form,})

    # return render(request,'oauth/profile.html',context={'detailForm':detailForm,'form':form})


class Change_profile(View):
    @method_decorator(login_auth)
    def dispatch(self, request, *args, **kwargs):
        return super(Change_profile, self).dispatch(request, *args, **kwargs)

    def post(self,request):
        user = User.objects.filter(id=request.session.get('user_info')['uid']).first()
        # user_id = request.user.id
        # userinfo = UserProfile.objects.get(user=user_id)
        user_body_info = BodyManage.objects.get(user=user)
        body_form = BodyForm(instance=user_body_info)
        # 更新哪一个表单就一定要有  request.POST这个参数!!!
        form = UserInfoForm(request.POST,instance=user)
        if form.is_valid():
            form.save()
            # 添加一条信息,表单验证成功就重定向到个人信息页面
            messages.add_message(request,messages.SUCCESS,'个人信息更新成功！')
            return redirect('userinfo:detail')
        else:
            return render(request, 'account/profile.html', context={'form':form,'body_form': body_form})



class SignupView(View):
    def get(self, request):
        return render(request, 'account/signup.html')

    def post(self, request):
        has_error = True
        if request.POST.get('check_code', None):
            # 判断验证码
            if request.session['CheckCode'].upper() == request.POST.get('check_code').upper():
                # Form验证
                obj = SignupForm(request.POST)
                if obj.is_valid():
                    has_error = False
                    username = obj.cleaned_data['username']
                    password = obj.cleaned_data['password1']
                    email = obj.cleaned_data['email']
                    # mobile = obj.cleaned_data['mobile']
                    default_avatar_url = get_default_avatar_url()
                    # 保存用户
                    # user_obj = UserProfile.objects.create(username=username,password=password, avatar=default_avatar_url)
                    user_obj = UserProfile()
                    user_obj.username = username
                    user_obj.email = email
                    user_obj.avatar = default_avatar_url
                    # user_obj.mobile = mobile
                    user_obj.set_password(password)
                    user_obj.save()
                    # 注册成功，创建用户details 表
                    UserDetails.objects.create(user=user_obj)
                    # 跳转到登录页
                    return redirect(reverse('signin'))
            else:
                code_error = "验证码错误"
        else:
            code_error = "请输入验证码"
        return render(request, 'account/signup.html', locals())


class SigninView(View):
    def get(self, request):
        next_url = request.GET.get('next', None)
        return render(request, 'account/login.html', locals())

    def post(self, request):
        has_error = True
        if request.POST.get('check_code', None):
            if request.session['CheckCode'].upper() == request.POST.get('check_code').upper():
                obj = SigninForm(request.POST)
                if obj.is_valid():
                    username = obj.cleaned_data['username']
                    password = obj.cleaned_data['password']
                    user_obj = UserProfile.objects.filter(Q(username=username) | Q(email=username)).first()
                    if user_obj:
                        if user_obj.check_password(password):
                            # 账号密码正确，登录成功 修改最后登录时间
                            user_obj.last_login = datetime.now()
                            # 获取用户本次session_key 记录到数据库中，以便在其他地方修改此用户的session 信息
                            user_obj.session = request.session.session_key
                            user_obj.save()

                                # 用户详细信息表 注册时已经创建，这里是防止admin等用户未创建产生的BUG
                            user_detail = UserDetails.objects.filter(user_id=user_obj.id).first()
                            if not user_detail:
                                user_detail = UserDetails.objects.create(user_id=user_obj.id)

                            # 获取用户基础信息，存放到session中，方便频繁调用
                            # 获取签到状态
                            signed_obj = SignedInfo.objects.filter(user_id=user_obj.id,
                                                                   date=datetime.now().strftime('%Y%m%d'),
                                                                   status=True).first()
                            if signed_obj:
                                signed_status = True
                            else:
                                signed_status = False
                            # 在seesion中加入一个是否是第三方登录的flg,以此来判断邮箱和密码验证采用哪一个系统
                            # 这里是采用自定制的邮箱和密码修改 20190706
                            socialAccountFlg = False

                            # 组装用户信息，并写入session中
                            user_info = {
                                'username': username,
                                'uid': user_obj.id,
                                'avatar': user_obj.avatar.url,
                                'mobile': user_obj.mobile,
                                'email': user_obj.email,
                                'favorite_node_num': FavoriteNode.objects.filter(favorite=1, user=user_obj).count(),
                                'favorite_topic_num': TopicVote.objects.filter(favorite=1, user=user_obj).count(),
                                'following_user_num': UserFollowing.objects.filter(is_following=1,
                                                                                   user=user_obj).count(),
                                'show_balance': user_detail.show_balance,
                                'balance': user_detail.balance,
                                'daily_mission': signed_status,
                                'isSocialAccount':socialAccountFlg,

                            }

                            # 登陆后页面跳转
                            if request.POST.get('next', None):
                                next_url = request.POST.get('next')
                            else:
                                next_url = reverse('index')
                            # 如果用户定义了登录后跳转，则跳转到用户指定页面
                            if user_detail.my_home:
                                next_url = user_detail.my_home
                            resp = redirect(next_url)
                            request.session['user_info'] = user_info
                            return resp
                        else:
                            user_error = '用户或密码错误'
                    else:
                        user_error = '用户不存在'
            else:
                code_error = "验证码错误"
        else:
            code_error = "请输入验证码"

        return render(request, 'account/login.html', locals())


class SignoutView(View):
    def post(self, request):
        # 如果用户登录了
        if request.session.get('user_info', None):
            # 删除登录用户统计信息
            online_key = 'count_online_id_{_id}_session_{_session}'.format(
                _id=request.session.get('user_info')['uid'], _session=request.session.session_key)
            cache.delete(online_key)
            # 清除 session 信息
            request.session.flush()
        return render(request, 'article/article_list.html')


class MemberView(View):
    def get(self, request, username):
        try:
            # 获取链接指向的用户名的obj
            user_obj = UserProfile.objects.get(username=username)
            # 通过当前查看的用户名获取用户id和session信息，然后在cache中查找此key
            # 1 判断用户是否在线 有此key  在线， 没有此key 离线 这里用此方式
            # 2 通过session 根据有没有此用户在数据库中存储的session 判断
            online_key = 'count_online_id_{_id}_session_{_session}'.format(
                _id=user_obj.id, _session=user_obj.session)
            online_status = cache.get(online_key)
            # 获取作者是连接中的用户的Topic主题
            topic_obj = Topic.objects.filter(author=user_obj).select_related('category').order_by('-create_time')
            if request.session.get('user_info', None):
                # 获取当前用户是否following 此用户 根据此来调整页面显示信息
                is_following = UserFollowing.objects.values_list('is_following').filter(is_following=1,
                                                                                        user_id=request.session.get(
                                                                                            'user_info')['uid'],
                                                                                        following=user_obj).first()
                # 获取当前用户是否block 此用户
                is_block = UserFollowing.objects.values_list('is_block').filter(is_block=1, user_id=request.session.get(
                    'user_info')['uid'], following=user_obj).first()

            return render(request, 'user/member.html', locals())
        # 没有此用户，指向没有的连接，返回404
        except UserProfile.DoesNotExist:
            raise Http404("Not Find This User")



# 由于用户验证是自己定制的,allauth的社交账户登录就没有把用户信息加入session的处理
# 于是这里加入一个接受第三方社交账号登录的信号,如果接收到这个信号就做余下处理20190706
@receiver(user_logged_in)
def login_social_user(sender, request, user, **kwargs):
    username = SocialAccount.objects.filter(user=user)[0]
    user_obj = UserProfile.objects.filter(Q(username=username) | Q(email=username)).first()

    user_detail = UserDetails.objects.filter(user_id=user_obj.id).first()
    if not user_detail:
        user_detail = UserDetails.objects.create(user_id=user_obj.id)

    # 获取签到状态
    signed_obj = SignedInfo.objects.filter(user_id=user_obj.id,
                                           date=datetime.now().strftime('%Y%m%d'),
                                           status=True).first()
    if signed_obj:
        signed_status = True
    else:
        signed_status = False
    # 在seesion中加入一个是否是第三方登录的flg,以此来判断邮箱和密码验证采用哪一个系统
    # 这里是采用allauth的的邮箱和密码修改 20190706
    socialAccountFlg = True

    # here login success
    # 组装用户信息，并写入session中
    user_info = {
        'username': user_obj.username,
        'uid': user_obj.id,
        # 'avatar':,
        'mobile': user_obj.mobile,
        'email': user_obj.email,
        'favorite_node_num': FavoriteNode.objects.filter(favorite=1, user=user_obj).count(),
        'favorite_topic_num': TopicVote.objects.filter(favorite=1, user=user_obj).count(),
        'following_user_num': UserFollowing.objects.filter(is_following=1,
                                                           user=user_obj).count(),
        'show_balance': user_detail.show_balance,
        'balance': user_detail.balance,
        'daily_mission': signed_status,
        'isSocialAccount':socialAccountFlg,
    }
    request.session['user_info'] = user_info