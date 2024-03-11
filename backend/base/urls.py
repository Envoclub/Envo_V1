"""
This urls.py contains urls for profile company and leaderboard with authentication
"""
from django.urls import path,include
from . import views

app_name = 'base' 

urlpatterns = [
   path('', include('dj_rest_auth.urls')),
   path('dj_rest_auth/user/', views.CustomUserDetailsView.as_view(),name="user-data"),
   path('profile/<str:pk>/',views.GetProfileListView.as_view(),name="Profile-list"),
   path('companies/', views.CompanyListCreateView.as_view(), name='create-company'),
   path('companies/<int:company_id>/employees/', views.EmployeeListByCompanyView.as_view(), name='company-employees'),
   path('leaders/', views.UserListAPIView.as_view(), name='user-list'),
   path('update-user/<int:pk>/', views.UserUpdateAPIView.as_view(), name='add-user-to-company'),
   path('delete-user/<int:company_id>/<int:pk>/', views.DeleteUserFromCompanyView.as_view(), name='delete-user-from-company'),  
   path('accounts/confirm-email/<str:key>/', views.CustomEmailConfirmationView.as_view(), name='account_confirm_email'),
   path('add-rewards/', views.AddRewardsViewSet.as_view(), name='add-reward'),

   
] 
