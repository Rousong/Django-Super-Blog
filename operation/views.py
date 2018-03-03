import json
from django.shortcuts import HttpResponse
from django.views.generic import View
from django.utils.decorators import method_decorator
from utils.auth_decorator import login_auth
from .models import Topic, TopicVote, FavoriteNode, TopicCategory
from .forms import TopicVoteForm, CheckTopicForm, CheckNodeForm
# Create your views here.


class TopicVoteView(View):
    @method_decorator(login_auth)
    def dispatch(self, request, *args, **kwargs):
        return super(TopicVoteView, self).dispatch(request, *args, **kwargs)

    def post(self, request):
        ret = {
            'changed': False,
            'topic_sn': '',
            'data': ''
        }
        user_info = request.session.get('user_info')
        uid = user_info['uid']
        obj = TopicVoteForm(request.POST)
        if obj.is_valid():
            ret['changed'] = True
            topic_sn = obj.cleaned_data['topic_sn']
            print(topic_sn)
            vote_action = obj.cleaned_data['vote_action']
            topic_obj = Topic.objects.filter(topic_sn=topic_sn).first()
            flag = 0
            if vote_action == 'up':
                flag = 1
            try:
                topic_vote_obj = TopicVote.objects.get(user_id=uid, topic=topic_obj)
                topic_vote_obj.vote = flag
                topic_vote_obj.save()
            except TopicVote.DoesNotExist:
                topic_vote_obj = TopicVote()
                topic_vote_obj.user_id = uid
                topic_vote_obj.vote = flag
                topic_vote_obj.topic = topic_obj
                topic_vote_obj.save()
            ret['topic_sn'] = topic_sn
            ret['data'] = '''
                <a href="javascript:" onclick="upVoteTopic('{_topic_sn}');" class="vote">
                <li class="fa fa-chevron-up">&nbsp;{_like_num}</li>
                </a> &nbsp;
                <a href="javascript:" onclick="downVoteTopic('{_topic_sn}');" class="vote">
                <li class="fa fa-chevron-down">&nbsp;{_dislike_num}</li>
                </a>
                '''.format(_like_num=topic_vote_obj.count_like(topic_obj),
                           _dislike_num=topic_vote_obj.count_dislike(topic_obj),
                           _topic_sn=topic_sn,)
        else:
            ret['changed'] = False
            ret['data'] = obj.errors.as_json()

        return HttpResponse(json.dumps(ret))


class FavoriteTopicView(View):
    @method_decorator(login_auth)
    def dispatch(self, request, *args, **kwargs):
        return super(FavoriteTopicView, self).dispatch(request, *args, **kwargs)

    def post(self, request):
        ret = {
            'changed': False,
            'topic_sn': '',
            'data': ''
        }
        user_info = request.session.get('user_info')
        uid = user_info['uid']
        obj = CheckTopicForm(request.POST)
        if obj.is_valid():
            ret['changed'] = True
            topic_sn = obj.cleaned_data['topic_sn']
            topic_obj = Topic.objects.filter(topic_sn=topic_sn).first()
            try:
                topic_vote_obj = TopicVote.objects.get(user_id=uid, topic=topic_obj)
                if topic_vote_obj.favorite == 1:
                    topic_vote_obj.favorite = 0
                    ret['data'] = "&nbsp;加入收藏&nbsp;"
                else:
                    topic_vote_obj.favorite = 1
                    ret['data'] = "&nbsp;取消收藏&nbsp;"
                topic_vote_obj.save()
            except TopicVote.DoesNotExist:
                topic_vote_obj = TopicVote()
                topic_vote_obj.user_id = uid
                topic_vote_obj.favorite = 1
                topic_vote_obj.topic = topic_obj
                topic_vote_obj.save()
                ret['data'] = "&nbsp;取消收藏&nbsp;"
            ret['topic_sn'] = topic_sn
        else:
            ret['changed'] = False
            ret['data'] = obj.errors.as_json()

        return HttpResponse(json.dumps(ret))


class ThanksTopicView(View):
    @method_decorator(login_auth)
    def dispatch(self, request, *args, **kwargs):
        return super(ThanksTopicView, self).dispatch(request, *args, **kwargs)

    def post(self, request):
        ret = {
            'changed': False,
            'topic_sn': '',
            'data': ''
        }
        user_info = request.session.get('user_info')
        uid = user_info['uid']
        obj = CheckTopicForm(request.POST)
        if obj.is_valid():
            ret['changed'] = True
            topic_sn = obj.cleaned_data['topic_sn']
            topic_obj = Topic.objects.filter(topic_sn=topic_sn).first()
            try:
                topic_vote_obj = TopicVote.objects.get(user_id=uid, topic=topic_obj)
                print(topic_vote_obj)
                if topic_vote_obj.thanks == 1:
                    ret['changed'] = False
                else:
                    topic_vote_obj.thanks = 1
                    topic_vote_obj.save()
            except TopicVote.DoesNotExist:
                topic_vote_obj = TopicVote()
                topic_vote_obj.user_id = uid
                topic_vote_obj.thanks = 1
                topic_vote_obj.topic = topic_obj
                topic_vote_obj.save()
                '''
                等待添加功能，联合查询此贴作者并修改金币数量，添加，并把此感谢者金币减少
                '''
            ret['data'] = "&nbsp;已经发送感谢&nbsp;"
            ret['topic_sn'] = topic_sn
        else:
            ret['changed'] = False
            ret['data'] = obj.errors.as_json()

        return HttpResponse(json.dumps(ret))


class FavoriteNodeView(View):
    @method_decorator(login_auth)
    def dispatch(self, request, *args, **kwargs):
        return super(FavoriteNodeView, self).dispatch(request, *args, **kwargs)

    def post(self, request):
        ret = {
            'changed': False,
            'node_code': '',
            'data': ''
        }
        user_info = request.session.get('user_info')
        uid = user_info['uid']
        obj = CheckNodeForm(request.POST)
        if obj.is_valid():
            ret['changed'] = True
            node_code = obj.cleaned_data['node_code']
            node_obj = TopicCategory.objects.filter(code=node_code, category_type=2).first()
            try:
                favorite_node_obj = FavoriteNode.objects.get(user_id=uid, node=node_obj)
                if favorite_node_obj.favorite == 1:
                    favorite_node_obj.favorite = 0
                    ret['data'] = "加入收藏"
                else:
                    favorite_node_obj.favorite = 1
                    ret['data'] = "取消收藏"
                favorite_node_obj.save()
            except FavoriteNode.DoesNotExist:
                favorite_node_obj = FavoriteNode()
                favorite_node_obj.user_id = uid
                favorite_node_obj.favorite = 1
                favorite_node_obj.node = node_obj
                favorite_node_obj.save()
                ret['data'] = "取消收藏"
            ret['node_code'] = node_code
        else:
            ret['changed'] = False
            ret['data'] = obj.errors.as_json()

        return HttpResponse(json.dumps(ret))
