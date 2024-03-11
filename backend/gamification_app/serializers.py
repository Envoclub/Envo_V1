from rest_framework import serializers
from .models import SustainableActionCategory,SustainableAction,Rewards

class SustainableActionCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = SustainableActionCategory
        fields = '__all__'

class SustainableActionSerializer(serializers.ModelSerializer):
    category = SustainableActionCategorySerializer()
    categoryID  = serializers.SerializerMethodField('get_categoryID')
    
    class Meta:
        model = SustainableAction
        fields = ['id', 'action', 'description', 'points', 'impact', 'category','categoryID', 'savedemmision', 'color', 'image']

    def get_categoryID(self,obj):
        return obj.category.pk

class RewardsSerializer(serializers.ModelSerializer):
    banner = serializers.CharField(write_only=True)  # Use CharField to accept the S3 URL

    class Meta:
        model = Rewards
        fields = '__all__'

    def create(self, validated_data):
        banner_url = validated_data.pop('banner')  # Get the S3 URL
        instance = super().create(validated_data)  # Create the model instance

        # Set the banner URL
        instance.banner = banner_url
        instance.save()

        return instance

class GetRewardsSerializer(serializers.ModelSerializer):
    # Use the custom S3URLField to accept S3 URLs
    class Meta:
        model = Rewards
        fields = '__all__'

    
    