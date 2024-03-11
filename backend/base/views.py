"""
All The Logic for the base Application is written here
"""
from rest_framework import generics
from rest_framework.response import Response
from dj_rest_auth.registration.views import RegisterView
from .serializers import CustomRegisterSerializer,ProfileSerializer,CompanySerializer,CustomUserCreateSerializer,CustomUserDetailSerializer
from .models import User,Company
from rest_framework.permissions import IsAuthenticated
from .permissions import IsCompanyOwner
from rest_framework import status
from allauth.account.views import PasswordResetFromKeyView
from django.utils.encoding import  force_str
from django.utils.http import  urlsafe_base64_decode
from django.utils.translation import gettext_lazy as _
from os import path
from allauth.account.forms import (
    EmailAwarePasswordResetTokenGenerator,
    ResetPasswordForm,
)
from allauth.account.utils import user_pk_to_url_str
from django.conf import settings
from django.core.mail import send_mail
from django.template.loader import render_to_string
from django.utils.translation import gettext_lazy as _
from allauth.account.views import SignupView
from allauth.account.models import EmailConfirmation
from django.shortcuts import redirect
from gamification_app.serializers import RewardsSerializer
from rest_framework import status
from django.core.files.storage import default_storage
from rest_framework.parsers import MultiPartParser, FormParser
from django.conf import settings
from django.core.files.base import ContentFile
from dj_rest_auth.views import UserDetailsView



class CustomUserDetailsView(UserDetailsView):
    serializer_class = CustomUserDetailSerializer

class SendInviteForm(ResetPasswordForm):
    """
    used to send an invitation to onboard the platform and reset the password
    """

    default_token_generator = EmailAwarePasswordResetTokenGenerator()

    def send_email_invite(self, email, uri, uid, token):
        context = {
            "uri": uri,
            "uid": uid,
            "token": token,
        }
        msg_plain = render_to_string("users/invite_with_password_reset.txt", context)
        msg_html = render_to_string("users/invite_with_password_reset.html", context)
        send_mail(
            "Welcome!",
            msg_plain,
            None,
            [email],
            html_message=msg_html,
        )

    def save(self, request, **kwargs):
        email = self.cleaned_data["email"]
        token_generator = kwargs.get("token_generator", self.default_token_generator)
        for user in self.users:
            temp_key = token_generator.make_token(user)
            uri = path.join(settings.CLIENT_BASE_URL, "he/welcome/reset-password")
            self.send_email_invite(email, uri, user_pk_to_url_str(user), temp_key)
        return self.cleaned_data["email"]

class CustomEmailConfirmationView(SignupView):
    # Set the name of the custom HTML email template
    template_name = 'account/email/email_confirmation_message.html'

    def get(self, request, *args, **kwargs):
        key = kwargs['key']
        email_confirmation = EmailConfirmation.objects.filter(key=key).first()
        if email_confirmation and not email_confirmation.email_address.verified:
            email_confirmation.confirm(request)
        return redirect('account_login')  # Redirect to your login view

class CustomRegistView(RegisterView):
    """
    This class registers the user
    """
    serializer_class = CustomRegisterSerializer

class CustomPasswordResetConfirmView(PasswordResetFromKeyView):
    def get_user(self, uidb64):
        try:
            uid = force_str(urlsafe_base64_decode(uidb64))
            user = User.objects.get(pk=uid)
            return user
        except (TypeError, ValueError, OverflowError, User.DoesNotExist):
            return None

class GetProfileListView(generics.ListAPIView,generics.UpdateAPIView):
    """
    View function For getting the profile
    """
    serializer_class = ProfileSerializer

    def get_queryset(self):
        """
        This function is to get queryset
        """
        pk = self.kwargs['pk']
        try:
            queryset = User.objects.filter(pk=int(pk))
            
        except:
            queryset = User.objects.filter(email=self.request.user.email)
        return queryset

class CompanyListCreateView(generics.ListCreateAPIView):
    """
    This class created company and retrieve information about it
    """
    queryset = Company.objects.all()
    serializer_class = CompanySerializer

      # Cache the queryset for 5 minutes
    def get_queryset(self):
        return self.queryset

class EmployeeListByCompanyView(generics.ListAPIView):
    """
    This class get's the employ list of each company
    """
    serializer_class = ProfileSerializer

    def get_queryset(self):
        """
        This function is to get company details by company id
        """
        company_id = self.kwargs['company_id']
        return User.objects.filter(company_id=company_id)
    
class UserListAPIView(generics.ListAPIView):
    """
    This class list the leaderboard according to the reward
    """
    queryset = User.objects.all().order_by('-reward')
    serializer_class = ProfileSerializer

class UserUpdateAPIView(generics.UpdateAPIView):
    queryset = User.objects.all()
    serializer_class = CustomUserCreateSerializer
    permission_classes = [IsAuthenticated]
    lookup_field = 'pk'

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        Image = request.data.get('photoUrl', None)
        bio = request.data.get('bio',None)
        
        if Image and bio:
            instance.photoUrl = Image
            instance.bio = bio
            instance.save()
        elif Image:
            instance.photoUrl = Image
            instance.save()
        elif bio:
            instance.bio = bio
            instance.save()
        else:
            raise ValueError("nothing to update")


        serializer = self.get_serializer(instance)
        return Response(serializer.data, status=status.HTTP_200_OK)

class DeleteUserFromCompanyView(generics.DestroyAPIView):
    serializer_class = CustomUserCreateSerializer
    permission_classes = [IsAuthenticated, IsCompanyOwner]

    def get_queryset(self):
        company_id = self.kwargs.get('company_id')
        company = Company.objects.get(pk=company_id)
        return company.employees.all()
    
class AddRewardsViewSet(generics.CreateAPIView):
    """
    This View add the rewards 
    """
    serializer_class = RewardsSerializer
    parser_classes = (MultiPartParser, FormParser)  # Add these parsers to handle multipart/form-data

    def create(self, request, *args, **kwargs):
        try:
            if 'banner_upload' in request.data:
                banner_upload = request.data['banner_upload']
                banner_bytes = banner_upload.read()

                file_path = default_storage.save(f'banner/{banner_upload.name}', ContentFile(banner_bytes))

                s3_base_url = f'https://{settings.AWS_STORAGE_BUCKET_NAME}.s3.amazonaws.com/'
                object_key = file_path

                complete_s3_url = s3_base_url + object_key

                serializer = self.get_serializer(data={
                    'company': request.data['company'],
                    'title': request.data['title'],
                    'description': request.data['description'],
                    'coinrequired': request.data['coinrequired'],
                    'banner': complete_s3_url,
                })
                serializer.is_valid(raise_exception=True)
                serializer.save()

                return Response(serializer.data, status=status.HTTP_201_CREATED)
            else:
                return Response({'detail': 'No banner data was submitted.'}, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({'detail': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)