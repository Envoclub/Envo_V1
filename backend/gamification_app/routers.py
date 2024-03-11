from django.urls import include, path
from rest_framework import routers
from .viewsets import SustainableActionCategoryViewSet, SustainableActionViewSet,RewardsViewSet

router = routers.DefaultRouter()

router.register('sustainable-action-categories', SustainableActionCategoryViewSet)
router.register('sustainable-actions', SustainableActionViewSet)
router.register('rewards', RewardsViewSet)


urlpatterns = [
    path('', include(router.urls)),
]