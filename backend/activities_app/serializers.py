"""
This Serializer.py is to serialize the data and return the data in json format
"""
from rest_framework import serializers
from .models import Post
from django.contrib.auth import get_user_model
from base.models import Profile
User = get_user_model()

class EachUserSerializer(serializers.ModelSerializer):
    """
    Serializer for each user containing their username of the source
    """
    usernames = serializers.CharField(source='username')

    class Meta:
        """
        This is meta class for post model 
        """
        model = Post
        fields = ('usernames',)

class PostSerializer(serializers.ModelSerializer):
    """
    Sending the Serialized post like photo and videos 
    """
    my_username = serializers.SerializerMethodField(read_only=True)
    photo_url = serializers.SerializerMethodField(read_only=True)
    likes = EachUserSerializer(read_only=True,many=True)
    action = serializers.SerializerMethodField('get_action')

    class Meta:
        """
        This is meta class for post model 
        """
        model = Post
        fields = [
            'pk',
            'description',
            'postUrl',
            'date_posted',
            'tags',
            'my_username',
            'photo_url',
            'like_count',
            'likes',
            'action',
            'active'
           ]
    
    def get_my_username(self , obj):
        """
        this is function for getting the username 
        """
        try:
            return obj.username
        except:
            return None
    
    def get_photo_url(self,obj):
        """
        this is function for getting the profile picture 
        """
        try:
            return f"{obj.photoUrl}"
        except:
            return None

    def get_likes(self,obj):
        """
        this is function for getting the like on picture 
        """
        return f"{obj.likes.usernames}"
    
    def get_action(self,obj):
        """
        this is function for getting the action
        """
        return obj.action.pk

class PieChartSerializer(serializers.Serializer):
    """
    This is a pie chart serializer that returns pie chart data
    """
    Co2 = serializers.SerializerMethodField()
    postcount = serializers.SerializerMethodField()
    username = serializers.SerializerMethodField()
    
    class Meta:
        model = Post
        fields = ['username','Co2','postcount']

    def get_Co2(self,obj):
        return obj.user.Co2
    
    def get_postcount(self,obj):
        return obj.postcount

    def get_username(self,obj):
        return obj.user.username

    

class CO2UpdateSerializer(serializers.ModelSerializer):
    """
    This is the serializer to update the C02 field
    """
    class Meta:
        model = User
        fields = ['Co2']

class PostCountSerializer(serializers.Serializer):
    """
    This serializer is to create count for the post
    """
    date = serializers.DateField()
    post_count = serializers.IntegerField()

    class Meta:
        fields = ['date', 'post_count']