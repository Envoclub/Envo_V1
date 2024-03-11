'''
This Module Contains all the urls and routes for activities app
'''
from django.urls import path
from . import views

app_name = 'activities_app'

urlpatterns = [
    path('', views.PostListCreateView.as_view(),name="Create-Post"),
    path('like/', views.PostLikeListCreateView,name="Like-Post"),
    path('verify/', views.PostVerifyListCreateView,name="Like-Post"),
    path('users/<int:user_id>/posts/', views.UserPostsAPIView.as_view(), name='user-posts'),
    path("api/pie-chart/", views.PieChartView.as_view(), name="pie-chart-api"),
    path("api/bar-chart/", views.SustainableActionEveryday.as_view(), name="pie-chart-api"),
    path("api/tiles/", views.TileChartView.as_view(), name="bar-chart-api"),
    path("<int:pk>/values/", views.UpdateCO2LevelAPIView.as_view(), name="assumption-api"),
    path("<int:company_id>/co2-saved/", views.Co2SavedLast7DaysView.as_view(), name="bar-chart-api"),
]