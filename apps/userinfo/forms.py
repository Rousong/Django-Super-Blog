import re

from django import forms
from .models import  UserProfile
from django.core.exceptions import ValidationError
from PIL import Image
from django import forms
from django.core.files import File
from apps.workout.models import BodyManage

from crispy_forms.helper import FormHelper
from crispy_forms.layout import Layout, Submit, Row, Column,HTML
# 增加表单的bootstrap样式
from crispy_forms.bootstrap import AppendedText


class UserInfoForm(forms.ModelForm):
    class Meta:
        model = UserProfile
        fields = ['link','blood','gender','startWorkout']

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        # 这句相当重要，可以把所有输出的Form设置成不可编辑的
        # for nam, field in self.fields.items():
        #     field.disabled = True


        self.helper = FormHelper()
        self.helper.form_method = 'post'
        self.helper.form_action = '/userinfo/profile/change/'
        self.helper.layout = Layout(
            'link',
            Row(
                Column('gender', css_class='form-group col-md-6 mb-0'),
                Column('blood', css_class='form-group col-md-6 mb-0'),
            ),
            'startWorkout',
            Submit('save', '修改基础资料')
        )



class BodyForm(forms.ModelForm):
    # height = forms.CharField(max_length=3)

    class Meta:
        model = BodyManage
        fields = ['height','weight','weightMb','BMI','fat_rate','biwei','jiankaun','yaowei','tunwei',
                  'datuiwei','jiaohuai', 'shouwan','bowei','jiaochang','BMR','TDEE','zt','xiongwei','fat_rateMb']
        # fields = '__all__'  # 如果是全部获取可以这么写 但是这样表单不全的话会提交错误

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.helper = FormHelper()

        # 指定form的方法是post
        self.helper.form_method = 'post'
        # 指定form post的地址
        self.helper.form_action = '/userinfo/detail/updata/'
        self.helper.layout = Layout(
            Row(
                AppendedText('weight', 'kg',css_class='input-group col-md-5 mb-0'),
                # 这个可以在input里面加入一个单位 如cm kg
                AppendedText('height', 'cm',css_class='input-group col-md-5 mb-0'),
                AppendedText('weightMb', 'kg',css_class='input-group col-md-5 mb-0'),
                Column('zt', css_class='form-group col-lg-4 col-md-4 mb-0'),
                css_class='form-row'
            ),
            Row(
                Column('fat_rate', css_class='form-group col-lg-3 col-md-3 mb-0'),
                Column('BMI', css_class='form-group col-lg-3 col-md-3 mb-0'),
                Column('BMR', css_class='form-group col-lg-3 col-md-3 mb-0'),
                Column('TDEE', css_class='form-group col-lg-3 col-md-3 mb-0'),
                css_class='form-row'
            ),
            Row(
                Column('xiongwei', css_class='form-group col-lg-3 col-md-3 mb-0'),
                Column('biwei', css_class='form-group col-lg-3 col-md-3 mb-0'),
                Column('jiankaun', css_class='form-group col-lg-3 col-md-3 mb-0'),
                Column('yaowei', css_class='form-group col-lg-3 col-md-3 mb-0'),
                css_class='form-row'
            ),
            Row(
                Column('tunwei', css_class='form-group col-lg-3 col-md-3 mb-0'),
                Column('datuiwei', css_class='form-group col-lg-3 col-md-3 mb-0'),
                Column('jiaohuai', css_class='form-group col-lg-3 col-md-3 mb-0'),
                Column('shouwan', css_class='form-group col-lg-3 col-md-3 mb-0'),
                css_class='form-row'
            ),
            Row(
                Column('bowei', css_class='form-group col-lg-3 col-md-3 mb-0'),
                Column('jiaochang', css_class='form-group col-lg-3 col-md-3 mb-0'),
                Column('fat_rateMb', css_class='form-group col-lg-3 col-md-3 mb-0'),
                css_class='form-row'
            ),
            # 'check_me_out',
            Submit('save', '更新资料')
        )




class PhotoForm(forms.ModelForm):
    x = forms.FloatField(widget=forms.HiddenInput())
    y = forms.FloatField(widget=forms.HiddenInput())
    width = forms.FloatField(widget=forms.HiddenInput())
    height = forms.FloatField(widget=forms.HiddenInput())

    class Meta:
        model = UserProfile
        fields = (
            'avatar',
            'x',
            'y',
            'width',
            'height',
        )

    def save(self, commit=True, id=None):

        if UserProfile.objects.get(id=id):
            userinfo = UserProfile.objects.get(id=id)
            userinfo.avatar = super(PhotoForm, self).save(commit=False).avatar
        else:
            userinfo = super(PhotoForm, self).save(commit=False)
            userinfo.id = id

        userinfo.save()

        x = self.cleaned_data.get('x')
        y = self.cleaned_data.get('y')
        w = self.cleaned_data.get('width')
        h = self.cleaned_data.get('height')

        image = Image.open(userinfo.avatar)
        cropped_image = image.crop((x, y, w + x, h + y))
        resized_image = cropped_image.resize((150, 150), Image.ANTIALIAS)
        resized_image.save(userinfo.avatar.path)

        return userinfo



def mobile_validate(value):
    mobile_re = re.compile(r'^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$')
    if not mobile_re.match(value):
        raise ValidationError('手机号码格式错误')


def user_unique_validate(username):
    user_obj = UserProfile.objects.filter(username=username).first()
    if user_obj:
        raise ValidationError('此用户名已经存在，请换一个')


def username_rule_validate(value):
    # 先设定一个正则，非 [a-z][0-9]
    username_re = re.compile(r'\W|[A-Z]')
    # 判断如果查找所有的数据后有正则中的指定的字符串
    if username_re.findall(value):
        # 说明匹配，但是匹配就是非[a-z][0-9]  而我们想要的是[a-z][0-9]
        raise ValidationError('用户名格式错误 只能在[a-z][0-9]中选择')
    # 不匹配，说明 value 全在 [a-z][0-9] 这个范围里


def email_unique_validate(email):
    user_obj = UserProfile.objects.filter(email=email).first()
    if user_obj:
        raise ValidationError('Email已经存在，请换一个')


class SignupForm(forms.Form):
    username = forms.CharField(validators=[user_unique_validate, username_rule_validate, ], required=True,
                               max_length=30, min_length=5,
                               error_messages={'required': '用户名不能为空', 'max_length': '用户名至少5位',
                                               'min_length': '用户名最多30位'})
    password = forms.CharField(min_length=6, max_length=50, required=True,
                               error_messages={'required': '密码不能为空',
                                               'invalid': '密码格式错误',
                                               'min_length': '密码不能少于6位',
                                               'max_length': '密码最多50位'})
    email = forms.EmailField(validators=[email_unique_validate, ], required=True,
                             error_messages={'required': '邮箱不能为空', 'invalid': '邮箱格式错误'})
    mobile = forms.CharField(validators=[mobile_validate, ], required=True,
                             error_messages={'required': '手机号不能为空'})


class SigninForm(forms.Form):
    username = forms.CharField(required=True, max_length=50,
                               error_messages={'required': '用户名不能为空'}, )
    password = forms.CharField(min_length=6, max_length=50, required=True,
                               error_messages={'required': '密码不能为空',
                                               'invalid': '密码格式错误',
                                               'min_length': '密码不能少于6位'})
