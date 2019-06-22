from rest_framework.serializers import (
    ModelSerializer,
    HyperlinkedIdentityField,
    SerializerMethodField,
)

from apps.article.models import ArticlesPost

from apps.comments.api.serializers import CommentForArticleSerializer
from apps.comments.models import Comment


class ArticleCreateUpdateSerializer(ModelSerializer):
    comments = SerializerMethodField()
    column_r = SerializerMethodField()
    comic_r = SerializerMethodField()

    class Meta:
        model = ArticlesPost
        fields = [
            'id',
            'title',
            'comic_title',
            'column',
            'comic',
            'column_r',
            'comic_r',
            'comic_sequence',
            'body',
            'created',
            'comments',
        ]
        read_only_fields = [
            'created',
        ]
        extra_kwargs = {
            'comic_sequence': {'write_only': True},
            'column': {'write_only': True},
            'comic': {'write_only': True},
        }

    def get_comments(self, obj):
        c_qs = Comment.objects.filter(article=obj.id)
        comments = CommentForArticleSerializer(c_qs, many=True, context=self.context).data
        return comments

    def get_column_r(self, obj):
        try:
            result = obj.column.title
        except:
            result = None
        return result

    def get_comic_r(self, obj):
        try:
            result = obj.comic.title
        except:
            result = None
        return result


class ArticleListSerializer(ModelSerializer):
    url = HyperlinkedIdentityField(
        view_name='api_article:detail',
    )
    column = SerializerMethodField()
    comic = SerializerMethodField()
    # comment_counts = SerializerMethodField()

    class Meta:
        model = ArticlesPost
        fields = [
            'url',
            'id',
            'title',
            'column',
            'comic',
            # 'comment_counts',
            'total_views',
        ]

    def get_column(self, obj):
        if obj.column:
            return str(obj.column)
        else:
            return None

    def get_comic(self, obj):
        if obj.comic:
            return str(obj.comic)
        else:
            return None

    # def get_comment_counts(self, obj):
    #     c_qs = Comment.objects.filter(article=obj.id)
    #     return c_qs.count()
