"""
All The Logic for the Activities Application is written here
"""
from django.shortcuts import get_object_or_404
from .models import Post
from .serializers import PostSerializer,PostCountSerializer
from base.models import Company,Profile
from base.serializers import ProfileSerializer
from rest_framework import generics ,status
from rest_framework.decorators import api_view
from django.http import JsonResponse
from django.db.models import Count , Sum
from datetime import datetime, timedelta,date
from rest_framework.views import APIView
from rest_framework.response import Response
from gamification_app.models import SustainableAction
from rest_framework.permissions import IsAuthenticated
from django.utils import timezone
from django.db.models.functions import ExtractWeekDay,TruncDate
from django.contrib.auth import get_user_model
User = get_user_model()



class PostListCreateView(generics.ListCreateAPIView):
    """
    This module is to create and retrieve Posts of the user
    """
    serializer_class = PostSerializer
    queryset = Post.objects.all().order_by("-date_posted")

    def perform_create(self, serializer):
        """
        This is function to create a Post and sending the signals
        """
        pk = serializer.validated_data.get('pk')
        action_id = int(self.request.data.get('action'))
        
        queryset = Post.objects.filter(pk=pk)
        if queryset.exists():
            pass
        serializer.save(user=self.request.user,action_id=action_id)


@api_view(["POST"])
def PostLikeListCreateView(request,*args,**kwargs):
    """
    This module is functionality of like of the post
    """
    data = request.data
    post = get_object_or_404(Post,id=data['pk'])
    if post.likes.filter(id=request.user.id).exists():
            post.likes.remove(request.user)
            post.like_count -=1
            post.save()
    else:
        post.likes.add(request.user)
        post.like_count +=1
        post.save()

    return JsonResponse({"likes":post.like_count}) 


@api_view(["POST"])
def PostVerifyListCreateView(request,*args,**kwargs):
    """
    This function is to pass the verification if the post is verified
    """
    data = request.data
    post = get_object_or_404(Post,id=data['pk'])
    if post.active:
            post.active = False
            post.save()
    else:
        post.active = True
        post.save()

    return JsonResponse({"verified":post.active}) 



class UserPostsAPIView(generics.ListAPIView):
    """
    This api retrieves the user posts
    """
    serializer_class = PostSerializer

    
    def get_queryset(self):
        user_id = self.kwargs['user_id']
        return Post.objects.filter(user_id=user_id)

class PieChartView(APIView):
    """
    This view gets api view for the pie chart
    """
    
    def get(self, request):
        
        # Calculate the date range for the last month
        last_month = datetime.now() - timedelta(days=30)

        # Query the posts and count the number of posts for each action
        posts = Post.objects.filter(user__company_id=self.request.user.company.pk, date_posted__gte=last_month)
        action_counts = posts.values('action').annotate(count=Count('action'))

        # Retrieve all sustainable actions
        actions = SustainableAction.objects.all()

        # Create the data for the pie chart
        chart_data = [
            {
                'action': action.action,
                'count': next((count['count'] for count in action_counts if count['action'] == action.id), 0)
            }
            for action in actions
        ]

        return Response(chart_data)

class TileChartView(APIView):
    """
    This Class creates date for the Chart
    """
    
    def get(self, request):
        last_month = datetime.now() - timedelta(days=30)
        last_two_month = datetime.now() - timedelta(days=60)

        # Retrieve all sustainable actions
     
        carbon_emmision_saved = User.objects.filter(company_id=self.request.user.company.pk).aggregate(total_count=Sum('Co2'))['total_count']
        total_post = Post.objects.filter(user__company=self.request.user.company.pk,date_posted__gte=last_month).aggregate(total_count=Count('active'))['total_count']
        post_today = Post.objects.filter(user__company=self.request.user.company.pk,date_posted__gte=datetime.now() - timedelta(days=1)).distinct().count()
        percentage_total_post = Post.objects.filter(user__company=self.request.user.company.pk,date_posted__gte=last_two_month).aggregate(total_count=Count('active'))['total_count'] - total_post
        try:
            percentage_total_post = (percentage_total_post - total_post / percentage_total_post + total_post) * 100
        except:
            percentage_total_post = 100

        # Create the data for the pie chart
        chart_data = {
            "carbon_emmision_saved":carbon_emmision_saved,
            "Total_participation":total_post,
            'Total_Post_Today':post_today,
            'percentage_total_post':percentage_total_post,
            'percentage_Co2_change':0,
            'percentage_employee_participation':0
        }


        return Response(chart_data)
    
class Co2SavedLast7DaysView(generics.RetrieveAPIView):
    """
    This for a week C02 Saved
    """
    
    def get(self, request, *args, **kwargs):
        try:
            # Get the current date
            today = timezone.now().date()

            # Calculate the date 7 days ago
            seven_days_ago = today - timezone.timedelta(days=7)

            # Get the company_id from the URL
            company_id = self.kwargs.get('company_id')

            # Get the company
            company = Company.objects.get(pk=company_id)

            # Calculate the total CO2 saved by all users of the company in the last 7 days
            co2_saved_by_day = Post.objects.filter(user__company=company, date_posted__gte=seven_days_ago)\
                .annotate(day_of_week=ExtractWeekDay('date_posted'))\
                .values('day_of_week')\
                .annotate(total_co2_saved=Sum('user__Co2'))

            # Create a dictionary to map day_of_week number to day name
            day_mapping = {
                1: 'Monday',
                2: 'Tuesday',
                3: 'Wednesday',
                4: 'Thursday',
                5: 'Friday',
                6: 'Saturday',
                7: 'Sunday'
            }

            # Create a list to store the CO2 saved data for each day
            co2_saved_data = []

            # Iterate through the results and add the data to the list
            for entry in co2_saved_by_day:
                day_of_week = entry['day_of_week']
                total_co2_saved = entry['total_co2_saved']
                day_name = day_mapping.get(day_of_week, 'Unknown')
                co2_saved_data.append({'day': day_name, 'co2_saved': total_co2_saved})

            # Return the response
            return Response({'co2_saved_last_7_days': co2_saved_data}, status=status.HTTP_200_OK)

        except Company.DoesNotExist:
            return Response({'error': 'Company not found'}, status=status.HTTP_404_NOT_FOUND)
    
class UpdateCO2LevelAPIView(generics.UpdateAPIView):
    """
    This is to display Co2 level and update the Co2 assumption 
    """
    queryset = User.objects.all()
    serializer_class = ProfileSerializer
    permission_classes = [IsAuthenticated]
    lookup_field = 'pk'

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        new_co2_level = request.data.get('co2', None)
        if new_co2_level is None:
            return Response({'error': 'CO2 level must be provided in the request body.'}, status=status.HTTP_400_BAD_REQUEST)

        instance.Co2_assumption = new_co2_level
        instance.survey_completed = True
        instance.save()

        serializer = self.get_serializer(instance)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
class SustainableActionEveryday(APIView):
    """
    As the name suggest it is the chart that displays sustainable action
    taken everyday
    """
    
    def get(self, request):
        # Calculate the start and end dates for the desired period
        today = date.today()
        start_date = today - timedelta(days=6)

        # Query the database for post counts by date for the specified company
        post_counts = (
            Profile.objects
            .filter(user__company_id=self.request.user.company.id, created_at__date__range=(start_date, today))
            .annotate(date=TruncDate('created_at'))
            .values('date')
            .annotate(post_count=Count('id'))
            .order_by('date')
        )

        serializer = PostCountSerializer(post_counts, many=True)

        return Response(serializer.data)