"""
All The Logic for the Gamification Application is written here
"""
from rest_framework import viewsets
from .models import SustainableActionCategory, SustainableAction,Rewards
from .serializers import SustainableActionCategorySerializer, SustainableActionSerializer,RewardsSerializer,GetRewardsSerializer
from rest_framework.decorators import action
from django.http import JsonResponse


class SustainableActionCategoryViewSet(viewsets.ModelViewSet):
    """
    This creates and returns the sustainable action category
    """
    queryset = SustainableActionCategory.objects.all()
    serializer_class = SustainableActionCategorySerializer

class SustainableActionViewSet(viewsets.ModelViewSet):
    """
    This creates and returns the sustainable action 
    """
    queryset = SustainableAction.objects.all()
    serializer_class = SustainableActionSerializer


        
class RewardsViewSet(viewsets.ModelViewSet):
    """
    This creates and returns the Rewards and redeem it 
    """
    queryset = Rewards.objects.all()
    serializer_class = GetRewardsSerializer

    @action(detail=True, methods=['post'])
    def redeem(self, request, pk=None):
        """
        This is the function to redeem the reward
        """
        reward = self.get_object()
        coinrequired = reward.coinrequired

        if coinrequired <= request.user.reward:
            request.user.reward -= coinrequired
            request.user.save()

            reward.redeemed_count += 1
            reward.save()
            return JsonResponse({'message': 'Reward redeemed successfully.'})
        else:
            return JsonResponse({'message': 'Insufficient coins to redeem the reward.'})