from django.urls import reverse_lazy
from django.contrib.auth.decorators import login_required
from django.shortcuts import render,redirect
from django.http import JsonResponse, HttpResponse, Http404
from django.contrib.auth.hashers import check_password
from django.views.generic import View
from django.urls import reverse
from datetime import datetime
from django.db.models import Q
from io import BytesIO
from utils.check_code import create_validate_code

from apps.topic.models import Topic
from .forms import PhotoForm
from .models import UserInfo, get_default_avatar_url, UserFollowing
from apps.workout.models import BodyManage
from .forms import UserInfoForm,BodyForm
from .forms import SignupForm, SigninForm
from apps.operation.models import UserDetails, SignedInfo, FavoriteNode, TopicVote
from django.core.cache import cache

from allauth.account.views import EmailView
from braces.views import LoginRequiredMixin

from .models import UserProfile
from allauth.account.models import EmailAddress
from django.contrib import messages



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


class UserInfoView(LoginRequiredMixin, EmailView):
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
            userinfo = UserInfo.objects.get(user_id=user_id)

        except:
            userinfo = UserInfo.objects.create(user_id=user_id)

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

@login_required
def test(request):

    user_id = request.user.id

    try:
        userinfo = UserInfo.objects.get(user_id=user_id)

    except:
        userinfo = UserInfo.objects.create(user_id=user_id)

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


@login_required(login_url='/accounts/login')
def crop_upload_handler(request):
    """
    裁剪并上传用户头像
    """
    if request.method == 'POST':
        form = PhotoForm(request.POST, request.FILES)
        if form.is_valid():
            user_id = request.user.id
            form.save(user_id=user_id)
    return redirect('userinfo:detail')

@login_required
def updata_view(request):
    if request.method == 'POST':
        user_id = request.user.id
        userinfo = UserInfo.objects.get(user_id=user_id)
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

@login_required
def change_profile_view(request):
    if request.method == 'POST':
        user_id = request.user.id
        userinfo = UserInfo.objects.get(user_id=user_id)
        user_body_info = BodyManage.objects.get(user=request.user)
        body_form = BodyForm(instance=user_body_info)
        # 更新哪一个表单就一定要有  request.POST这个参数!!!
        form = UserInfoForm(request.POST,instance=userinfo)
        if form.is_valid():
            form.save()
            # 添加一条信息,表单验证成功就重定向到个人信息页面
            messages.add_message(request,messages.SUCCESS,'个人信息更新成功！')
            return redirect('userinfo:detail')
        else:
            return render(request, 'account/profile.html', context={'form':form,'body_form': body_form})



class SignupView(View):
    def get(self, request):
        return render(request, 'user/signup.html')

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
                    password = obj.cleaned_data['password']
                    email = obj.cleaned_data['email']
                    mobile = obj.cleaned_data['mobile']
                    # 保存用户
                    user_obj = UserProfile()
                    user_obj.username = username
                    user_obj.email = email
                    user_obj.mobile = mobile
                    user_obj.set_password(password)
                    user_obj.save()
                    # 注册成功，创建用户details 表
                    UserDetails.objects.create(user_id=user_obj.id)
                    # 跳转到登录页
                    return redirect(reverse('signin'))
            else:
                code_error = "验证码错误"
        else:
            code_error = "请输入验证码"
        return render(request, 'user/signup.html', locals())


class SigninView(View):
    def get(self, request):
        next_url = request.GET.get('next', None)
        return render(request, 'user/signin.html', locals())

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

                            # 组装用户信息，并写入session中
                            user_info = {
                                'username': username,
                                'uid': user_obj.id,
                                'avatar': user_obj.avatar,
                                'mobile': user_obj.mobile,
                                'favorite_node_num': FavoriteNode.objects.filter(favorite=1, user=user_obj).count(),
                                'favorite_topic_num': TopicVote.objects.filter(favorite=1, user=user_obj).count(),
                                'following_user_num': UserFollowing.objects.filter(is_following=1,
                                                                                   user=user_obj).count(),
                                'show_balance': user_detail.show_balance,
                                'balance': user_detail.balance,
                                'daily_mission': signed_status,
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
        return render(request, 'user/signin.html', locals())


class SignoutView(View):
    def get(self, request):
        # 如果用户登录了
        if request.session.get('user_info', None):
            # 删除登录用户统计信息
            online_key = 'count_online_id_{_id}_session_{_session}'.format(
                _id=request.session.get('user_info')['uid'], _session=request.session.session_key)
            cache.delete(online_key)
            # 清除 session 信息
            request.session.flush()
        return render(request, 'user/signout.html')


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
            topic_obj = Topic.objects.filter(author=user_obj).select_related('category').order_by('-add_time')
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



