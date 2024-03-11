

# **Backend**

This directory houses the robust API powered by Django REST Framework (DRF) for your Envo application.

- **Technology:** Python (Django REST Framework)
- **Deployment:** AWS Lambda using Zappa
- **Database:** AWS RDS (Relational Database Service)

**Backend Directory Structure:**

- `.`: Main root directory of the backend project.
- `.ebextensions` (Optional): Directory for AWS Elastic Beanstalk extensions (not applicable with Zappa deployment).
- `backend` (**Core Django Application Directory**): Contains the heart of your API code.
  - `activities_app` (Example app directory): Likely houses specific API endpoints related to activities.
  - `gamification_app` (Example app directory): Could contain API endpoints for gamification features.
  - `base.py` (Optional): Base classes or configuration shared across multiple app directories.
  - `manage.py`: Crucial Django management script for project-level tasks (migrations, shell, commands).
  - `media` (Optional): Directory for user-uploaded media files (images, videos, etc.).
  - `requirements.txt`: Text file listing all required Python dependencies for the backend project.
  - `static` (Optional): Directory for static assets that can be served directly by Django (CSS, JavaScript).
  - `templates` (Optional): Directory for Django templates if you're utilizing a templating engine.
  - `zappa_settings.json`: Configuration file for Zappa deployment to AWS Lambda.

**Using Django REST Framework (DRF):**

- DRF simplifies building RESTful APIs in Django. It provides:
  - Serializers (convert Python objects to JSON and vice versa).
  - ViewSets (handle CRUD operations for model resources).
  - Permissions (control API access based on user roles).
  - Authentication (manage user authentication and authorization).
- Refer to the official DRF documentation for detailed usage and best practices: [https://www.django-rest-framework.org/tutorial/quickstart/](https://www.django-rest-framework.org/tutorial/quickstart/)

**AWS Lambda and Zappa Deployment:**

- **AWS Lambda** is a serverless compute service that allows you to run code without managing servers.
- **Zappa** is a deployment framework that simplifies deploying Django applications to AWS Lambda.

**RDS (Relational Database Service):**

- RDS provides a managed relational database service in the cloud. You can choose different database engines like MySQL, PostgreSQL, etc.
- Configure your Django settings to connect to your RDS instance.
- Consult the AWS documentation for setting up RDS with your chosen database engine: [https://aws.amazon.com/rds/](https://aws.amazon.com/rds/)

**Getting Started (Backend):**

1. **Prerequisites:** Ensure you have Python (version compatible with Django and DRF) and `pip` (package manager) installed.
2. **Install Dependencies:**
   ```bash
   cd backend
   pip install -r requirements.txt
   ```
3. **Configure Django Settings:**
   - Update `DATABASES` settings in `backend/settings.py` to connect to your RDS instance.
   - Set `ALLOWED_HOSTS` with your domain or IP address to allow API requests.
   - Consider using environment variables for sensitive information (passwords, API keys) using a library like `django-environ`.
4. **Setup Zappa:**
   - Install Zappa globally: `pip install zappa`
   - Configure Zappa settings in `zappa_settings.json`. Refer to Zappa documentation for details.
5. **Deploy to Lambda:**
   ```bash
   zappa deploy dev  # Deploys to a development stage
   # Or for production deployment
   zappa deploy prod
   ```



**Main Backend URLs Configuration:**

```python
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('accounts/', include('base.urls', namespace='base')),  # Authentication URLs
    path('activities/', include('activities_app.urls', namespace='activities_app')),  # Activity endpoints
    path('dj-rest-auth/registration/', include('dj_rest_auth.registration.urls')),  # User registration
    path('api/rest-auth/', include('dj_rest_auth.urls')),  # User authentication
    path('account/', include('allauth.urls')),  # Social authentication (optional)
    path('game/', include('gamification_app.routers')),  # Gamification endpoints (if applicable)
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
```

**Explanation:**

* `urlpatterns` list: This is the main list that holds all URL patterns for your backend API.
* `path('admin/', admin.site.urls)`: This maps the Django admin interface to the `/admin/` URL path.
* `path('accounts/', include('base.urls', namespace='base'))`: This includes URLs from the `base.urls` file (likely containing authentication and registration endpoints) under the `/accounts/` prefix and assigns the namespace `base` for them.
* `path('activities/', include('activities_app.urls', namespace='activities_app'))`: This includes URLs from the `activities_app.urls` file (containing activity-related API endpoints) under the `/activities/` prefix with the namespace `activities_app`.
* `path('dj-rest-auth/registration/', include('dj_rest_auth.registration.urls'))`: This includes URLs for user registration provided by `dj-rest-auth`.
* `path('api/rest-auth/', include('dj_rest-auth.urls'))`: This includes URLs for user authentication provided by `dj-rest-auth`.
* `path('account/', include('allauth.urls'))`: This includes URLs for social authentication (optional) if you're using `allauth`.
* `path('game/', include('gamification_app.routers'))`: This includes URLs for gamification features (if applicable) from the `gamification_app.routers` file.
* `urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)`: This serves user-uploaded media files from the `MEDIA_ROOT` directory.
* `urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)`: This serves static assets (CSS, JavaScript) from the `STATIC_ROOT` directory.



**Envo Activities API:**


The `activities_app` directory within the backend handles API endpoints related to user activities:

**1. Creating and Retrieving Posts (`views.py`):**

- `PostListCreateView` (generic class):
  - Lists all user posts ordered by the newest first.
  - Allows creating new posts with user association and action selection.

```python
class PostListCreateView(generics.ListCreateAPIView):
    serializer_class = PostSerializer
    queryset = Post.objects.all().order_by("-date_posted")

    def perform_create(self, serializer):
        serializer.save(user=self.request.user, action_id=int(self.request.data.get('action')))
```

- `PostLikeListCreateView` (`@api_view` decorator):
  - Handles liking/unliking posts.
  - Increments/decrements the post's `like_count` field accordingly.

```python
@api_view(["POST"])
def PostLikeListCreateView(request, *args, **kwargs):
    data = request.data
    post = get_object_or_404(Post, id=data['pk'])

    if post.likes.filter(id=request.user.id).exists():
        post.likes.remove(request.user)
        post.like_count -= 1
    else:
        post.likes.add(request.user)
        post.like_count += 1

    post.save()
    return JsonResponse({"likes": post.like_count})
```

- `PostVerifyListCreateView` (`@api_view` decorator):
  - Allows verification of posts (admin functionality).
  - Toggles the `active` field of a post to mark it as verified/unverified.

```python
@api_view(["POST"])
def PostVerifyListCreateView(request, *args, **kwargs):
    data = request.data
    post = get_object_or_404(Post, id=data['pk'])

    if post.active:
        post.active = False
    else:
        post.active = True

    post.save()
    return JsonResponse({"verified": post.active})
```

**2. User Posts (`views.py`):**

- `UserPostsAPIView` (generic class):
  - Retrieves posts belonging to a specific user identified by their ID.

```python
class UserPostsAPIView(generics.ListAPIView):
    serializer_class = PostSerializer

    def get_queryset(self):
        user_id = self.kwargs['user_id']
        return Post.objects.filter(user_id=user_id)
```

**3. Data Visualization API Endpoints (`views.py`):**

- `PieChartView` (APIView):
  - Calculates and retrieves post counts categorized by sustainable actions for the last month, displayed in a pie chart.

```python
class PieChartView(APIView):
    def get(self, request):
        # Calculate date range for the last month
        last_month = datetime.now() - timedelta(days=30)

        # Query posts, count actions, and retrieve all actions
        posts = Post.objects.filter(user__company_id=self.request.user.company.pk, date_posted__gte=last_month)
        action_counts = posts.values('action').annotate(count=Count('action'))
        actions = SustainableAction.objects.all()

        # Prepare chart data with action name and corresponding count
        chart_data = [
            {
                'action': action.action,
                'count': next((count['count'] for count in action_counts if count['action'] == action.id), 0)
            }
            for action in actions
        ]

        return Response(chart_data)
```


**2. User Posts (`views.py`):**

- `UserPostsAPIView` (generic class):
  - Retrieves posts belonging to a specific user identified by their ID.

```python
class UserPostsAPIView(generics.ListAPIView):
    serializer_class = PostSerializer

    def get_queryset(self):
        user_id = self.kwargs['user_id']
        return Post.objects.filter(user_id=user_id)
```

**3. Data Visualization API Endpoints (`views.py`):**

- `PieChartView` (APIView):
  - Calculates and retrieves post counts categorized by sustainable actions for the last month, displayed in a pie chart.

```python
class PieChartView(APIView):
    def get(self, request):
        # Calculate date range for the last month
        last_month = datetime.now() - timedelta(days=30)

        # Query posts, count actions, and retrieve all actions
        posts = Post.objects.filter(user__company_id=self.request.user.company.pk, date_posted__gte=last_month)
        action_counts = posts.values('action').annotate(count=Count('action'))
        actions = SustainableAction.objects.all()

        # Prepare chart data with action name and corresponding count
        chart_data = [
            {
                'action': action.action,
                'count': next((count['count'] for count in action_counts if count['action'] == action.id), 0)
            }
            for action in actions
        ]

        return Response(chart_data)
```

- `TileChartView` (APIView):
  - Provides a high-level overview of user activity within the company for the last month.

```python
class TileChartView(APIView):
    def get(self, request):
        last_month = datetime.now() - timedelta(days=30)
        last_two_month = datetime.now() - timedelta(days=60)

        # Retrieve total CO2 saved, active posts, today's posts, percentage change in posts, and placeholders for CO2 change and employee participation
        carbon_emmision_saved = User.objects.filter(company_id=self.request.user.company.pk).aggregate(total_count=Sum('Co2'))['total_count']
        total_post = Post.objects.filter(user__company=self.request.user.company.pk, date_posted__gte=last_month).aggregate(total_count=Count('active'))['total_count']
        post_today = Post.objects.filter(user__company=self.request.user.company.pk, date_posted__gte=datetime.now() - timedelta(days=1)).distinct().count()
        percentage_total_post = (Post.objects.filter(user__company=self.request.user.company.pk, date_posted__gte=last_two_month).aggregate(total_count=Count('active'))['total_count'] - total_post) / total_post * 100
        chart_data = {
            "carbon_emmision_saved": carbon_emmision_saved,
            "Total_participation": total_post,
            'Total_Post_Today': post_today,
            'percentage_total_post': percentage_total_post,
            'percentage_Co2_change': 0,  # Placeholder, implementation may vary
            'percentage_employee_participation': 0,  # Placeholder, implementation may vary
        }

        return Response(chart_data)
```

- `Co2SavedLast7DaysView` (generics.RetrieveAPIView):
  - Retrieves the total CO2 saved by all users in the company for the last 7 days, grouped by day of the week.

```python
class Co2SavedLast7DaysView(generics.RetrieveAPIView):
    def get(self, request, *args, **kwargs):
        try:
            today = timezone.now().date()
            start_date = today - timedelta(days=7)
            company_id = self.kwargs.get('company_id')
            company = Company.objects.get(pk=company_id)

            co2_saved_by_day = Post.objects.filter(user__company=company, date_posted__gte=start_date) \
                .annotate(day_of_week=ExtractWeekDay('date_posted')) \
                .values('day_of_week') \
                .annotate(total_co2_saved=Sum('user__Co2'))

            # Map day of week number to day name
            day_mapping = {
                1: 'Monday',
                2: 'Tuesday',
                3: 'Wednesday',
                4: 'Thursday',
                5: 'Friday',
                6: 'Saturday',
                7: 'Sunday'
            }

            # Prepare chart data with day name and corresponding CO2 saved
            co2_saved_data = []
            for entry in co2_saved_by_day:
                day_of_week = entry['day_of_week']
                total_co2_saved = entry['total_co2_saved']
                day_name = day_mapping.get(day_of_week, 'Unknown')
                co2_saved_data.append({'day': day_name, 'co2_saved': total_co2_saved})

            return Response({'co2_saved_last_7_days': co2_saved_data}, status=status.HTTP_200_OK)

        except Company.DoesNotExist:
            return Response({'error': 'Company not found'}, status=status.HTTP_404_NOT_FOUND)
```

* `UpdateCO2LevelAPIView` (generics.UpdateAPIView):
  * Allows users to update their CO2 assumption level, marking their survey completion.

```python
class UpdateCO2LevelAPIView(generics.UpdateAPIView):
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
```

* `SustainableActionEveryday` (APIView):
  * Provides data for a chart displaying the number of sustainable actions taken each day for the last week.

```python
class SustainableActionEveryday(APIView):
    def get(self, request):
        # Calculate start and end dates for the last week
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
```


**Base Application**

This application handles user authentication, authorization, company management, and profile functionalities.

**Models (base/models.py):**

* **User:**
  * Extends `AbstractBaseUser` and `PermissionsMixin` from Django for custom user model with roles.
  * `type` field: Defines user type (e.g., "EMPLOYEES", "EMPLOYER").
  * `username`, `email`, `password`, `phone_number`, `bio`, `photoUrl`, `company`, `reward`, `Co2`, `Co2_assumption`, `survey_completed`: Relevant user data fields.
  * `is_staff`, `is_active`: Permission fields.
  * `objects` managed by `CustomAccountManager` for creating users and superusers.
  * Related models:
    * `Company` (foreign key): Company the user belongs to.
* **Company:**
  * Represents a company within the Envo platform.
  * Fields: `name`, `description`, `address`, `created_at`, `updated_at`.
* **Profile:**
  * One-to-one relationship with the `User` model, storing additional profile information.
  * Fields: `user` (foreign key), `followers`, `following` (many-to-many relationships), `postcount`, `profImage`, `created_at`, `updated_at`.

**Serializers (base/serializers.py):**

* Not explicitly provided, but likely exist to convert model instances to JSON and vice versa during API interactions.

**Views (base/views.py):**

* **CustomUserDetailsView:**
  * Inherits from `UserDetailsView` (likely from `dj-rest-auth`) to provide custom user details.
  * Uses `CustomUserDetailSerializer` (not shown) for serialization.
* **SendInviteForm:**
  * A custom form used to send password reset invitations during user onboarding.
  * Overrides the default behavior to send an email with a reset link.
* **CustomEmailConfirmationView:**
  * Inherits from `SignupView` (likely from `allauth.account`) to handle custom email confirmation.
  * Sets a custom HTML template for the confirmation email.
* **CustomRegistView:**
  * Inherits from `RegisterView` (likely from `dj-rest-auth`) to provide custom user registration.
  * Uses `CustomRegisterSerializer` (not shown) for registration data handling.
* **CustomPasswordResetConfirmView:**
  * Inherits from `PasswordResetFromKeyView` (likely from `allauth.account`) for custom password reset confirmation.
  * Overrides the user retrieval logic to ensure the correct user is associated with the reset token.
* **GetProfileListView:**
  * Inherits from `generics.ListAPIView` and `generics.UpdateAPIView` to handle profile retrieval and updates.
  * Uses `ProfileSerializer` (not shown) for serialization.
  * Retrieves profiles either by ID or the requesting user's email.
* **CompanyListCreateView:**
  * Inherits from `generics.ListCreateAPIView` to handle company listing and creation.
  * Uses `CompanySerializer` (not shown) for serialization.
  * Caches the company queryset for improved performance.
* **EmployeeListByCompanyView:**
  * Inherits from `generics.ListAPIView` to retrieve a list of employees for a specific company.
  * Uses `ProfileSerializer` (not shown) for serialization.
* **UserListAPIView:**
  * Inherits from `generics.ListAPIView` to list users ordered by their rewards (leaderboard).
  * Uses `ProfileSerializer` (not shown) for serialization.
* **UserUpdateAPIView:**
  * Inherits from `generics.UpdateAPIView` to handle user updates.
  * Uses `CustomUserCreateSerializer` (not shown) for serialization.
  * Allows updating `photoUrl` (profile picture), `bio`, or both.
* **DeleteUserFromCompanyView:**
  * Inherits from `generics.DestroyAPIView` to handle deleting a user from a company.
  * Requires IsAuthenticated and IsCompanyOwner permissions.
* **AddRewardsViewSet:**
  * Inherits from `generics.CreateAPIView` to handle adding new rewards.
  * Uses `RewardsSerializer` (not shown) for serialization.
  * Accepts multipart form data, allowing for both reward data and banner image upload.
  * Saves the banner image to S3 storage using the


Absolutely! Here's the continuation of the Envo project documentation, incorporating explanations for the base application's URLs and additional notes:

**URLs (base/urls.py):**

* Defines URL patterns for the `base` application API endpoints.
* Includes URLs from `dj-rest-auth` for core authentication functionalities.
* Customizes specific endpoints for user management, profile access, company interaction, and leaderboards.

**Explanation:**

```python
from django.urls import path, include
from . import views

app_name = 'base'

urlpatterns = [
    path('', include('dj_rest_auth.urls')),
    path('dj_rest_auth/user/', views.CustomUserDetailsView.as_view(), name="user-data"),
    path('profile/<str:pk>/',views.GetProfileListView.as_view(),name="Profile-list"),
    path('companies/', views.CompanyListCreateView.as_view(), name='create-company'),
    path('companies/<int:company_id>/employees/', views.EmployeeListByCompanyView.as_view(), name='company-employees'),
    path('leaders/', views.UserListAPIView.as_view(), name='user-list'),
    path('update-user/<int:pk>/', views.UserUpdateAPIView.as_view(), name='add-user-to-company'),
    path('delete-user/<int:company_id>/<int:pk>/', views.DeleteUserFromCompanyView.as_view(), name='delete-user-from-company'),
    path('accounts/confirm-email/<str:key>/', views.CustomEmailConfirmationView.as_view(), name='account_confirm_email'),
    path('add-rewards/', views.AddRewardsViewSet.as_view(), name='add-reward'),
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
```

* `path('', include('dj_rest_auth.urls'))`: Includes core authentication URLs from `dj-rest-auth`.
* `path('dj_rest_auth/user/', views.CustomUserDetailsView.as_view(), name="user-data")`: Provides a custom endpoint for retrieving user details using `CustomUserDetailsView`.
* `path('profile/<str:pk>/',views.GetProfileListView.as_view(),name="Profile-list")`: Retrieves user profiles either by ID or the requesting user's email using `GetProfileListView`.
* `path('companies/', views.CompanyListCreateView.as_view(), name='create-company')`: Lists and creates companies using `CompanyListCreateView`.
* `path('companies/<int:company_id>/employees/', views.EmployeeListByCompanyView.as_view(), name='company-employees')`: Retrieves a list of employees for a specific company using `EmployeeListByCompanyView`.
* `path('leaders/', views.UserListAPIView.as_view(), name='user-list')`: Lists users ordered by their rewards (leaderboard) using `UserListAPIView`.
* `path('update-user/<int:pk>/', views.UserUpdateAPIView.as_view(), name='add-user-to-company')`: Allows updating user profile picture and bio using `UserUpdateAPIView`.
* `path('delete-user/<int:company_id>/<int:pk>/', views.DeleteUserFromCompanyView.as_view(), name='delete-user-from-company')`: Deletes a user from a company using `DeleteUserFromCompanyView` (requires authentication and company owner permission).
* `path('accounts/confirm-email/<str:key>/', views.CustomEmailConfirmationView.as_view(), name='account_confirm_email')`: Handles custom email confirmation with a custom HTML template using `CustomEmailConfirmationView`.
* `path('add-rewards/', views.AddRewardsViewSet.as_view(), name='add-reward')`: Creates new rewards with banner image upload using `AddRewardsViewSet`.
* `urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)`: Serves user-uploaded media files from the `MEDIA_ROOT` directory.
* `urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)`: Serves static assets (CSS, JavaScript) from the `STATIC_ROOT` directory.

**Remember:**

**Base Application - Best Practices**

* **Authentication and Authorization:**
  * Implement proper authentication and authorization mechanisms for API endpoints to restrict access based on user roles and permissions.
  * Consider using built-in Django permissions or third-party libraries like `django-rest-framework-permissions`.
* **Error Handling:**
  * Implement robust error handling to provide informative messages to users in case of API request failures.
  * Use appropriate HTTP status codes (e.g., 400 for bad requests, 401 for unauthorized access) and consider using custom error serializers for detailed error responses.
* **Documentation:**
  * Maintain clear and up-to-date API documentation using tools like `django-rest-framework-swagger` or `drf-yasg` for user reference.
  * Include detailed descriptions of endpoints, request parameters, response structures, and authentication requirements.
* **Testing:**
  * Write unit tests for models, views, and serializers to ensure code functionality and prevent regressions.
  * Consider using testing frameworks like `pytest` or `unittest` for comprehensive testing.
* **Security:**
  * Follow secure coding practices to prevent vulnerabilities like SQL injection and cross-site scripting (XSS).
  * Regularly update dependencies to address known security issues.
  * Consider security best practices for user password storage and handling.

**Further Considerations:**

* **Scalability:** If you anticipate a large user base or high API traffic, consider using asynchronous frameworks like `Django Channels` or `Celery` for handling background tasks and scaling your application effectively.
* **Social Features:** Depending on your project requirements, you might explore integrating social login options (e.g., Google Sign-In, Facebook Login) using libraries like `allauth`.
* **Third-Party Integrations:** The `base` application could potentially integrate with external services for functionalities like sending email notifications, SMS verification, or payment processing.


Here's the updated README incorporating explanations and code for the `gamification_app` models, URLs, and views:


**Gamification Application**

This application focuses on the gamification aspects of the Envo platform, including sustainable actions, rewards, and user points.

**Models (gamification_app/models.py):**

* **SustainableActionCategory:**
  * Represents a category of sustainable actions (e.g., "Transportation", "Energy Consumption").
  * Fields: `name` (textual name of the category).
* **SustainableAction:**
  * Represents an individual sustainable action within a category.
  * Fields:
    * `action` (textual description of the action).
    * `description` (detailed explanation of the action).
    * `points` (number of points awarded for completing the action).
    * `impact` (textual description of the environmental impact).
    * `category` (foreign key to `SustainableActionCategory`).
    * `savedemmision` (amount of CO2 emission saved by taking this action).
    * `color` (color code for the action's display).
    * `image` (optional image associated with the action).
* **Rewards:**
  * Represents rewards offered by companies to incentivize sustainable actions.
  * Fields:
    * `company` (foreign key to `base.Company`).
    * `banner` (optional URL for a reward banner image).
    * `title` (textual name of the reward).
    * `description` (detailed explanation of the reward).
    * `coinrequired` (number of points required to redeem the reward).
    * `redeemed_count` (number of times the reward has been redeemed).

**Serializers (gamification_app/serializers.py):**

* Not explicitly provided, but likely exist to convert model instances to JSON and vice versa during API interactions.
  * `SustainableActionCategorySerializer` (for serializing/deserializing `SustainableActionCategory` objects).
  * `SustainableActionSerializer` (for serializing/deserializing `SustainableAction` objects).
  * `RewardsSerializer` (for serializing/deserializing `Rewards` objects for creation and updates).
  * `GetRewardsSerializer` (likely for serializing/deserializing `Rewards` objects with redemption functionality).

**Views (gamification_app/viewsets.py):**

* **SustainableActionCategoryViewSet:**
  * Inherits from `viewsets.ModelViewSet` to provide CRUD (Create, Read, Update, Delete) operations for `SustainableActionCategory` objects using `SustainableActionCategorySerializer`.
* **SustainableActionViewSet:**
  * Inherits from `viewsets.ModelViewSet` to provide CRUD operations for `SustainableAction` objects using `SustainableActionSerializer`.
* **RewardsViewSet:**
  * Inherits from `viewsets.ModelViewSet` to provide CRUD operations for `Rewards` objects using `RewardsSerializer` (for creation/updates) and `GetRewardsSerializer` (for retrieval with redemption functionality).
  * Includes a custom `redeem` action method to handle reward redemption logic:
    * Retrieves the reward object based on the provided ID (pk).
    * Checks if the user has sufficient points to redeem the reward (compares `coinrequired` with the user's `reward` field).
    * If points are sufficient, deducts the required points from the user's total and saves the user instance.
    * Increments the reward's `redeemed_count` and saves the reward instance.
    * Returns a JSON response indicating successful redemption or insufficient points.

**Routers (gamification_app/routers.py):**

* Defines URL patterns for the `gamification_app` API endpoints using a `DefaultRouter` from `rest_framework`.
* Registers viewsets for `SustainableActionCategory`, `SustainableAction`, and `Rewards` for automatic URL generation.

**URLs (gamification_app/urls.py):**

* Includes URL patterns from the `gamification_app` router for a clean and organized structure.

**Additional Notes:**

* The provided code utilizes viewsets for a more concise and efficient approach to API endpoint creation compared to traditional class-based views.
* The custom `redeem` action method demonstrates how to extend viewset functionality for specific use cases.
* Consider incorporating user authentication and authorization checks in the views to restrict access based on user roles or permissions (e.g., company owners managing rewards).
 

