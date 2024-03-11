"""
Django includes a “signal dispatcher” which helps decoupled applications 
get notified when actions occur elsewhere in the framework. 
In a nutshell, signals allow certain senders to notify a set of receivers that some action has taken place.
Signal function for post and pre saving 
"""
from allauth.account.signals import email_confirmed
from .models import Profile
from django.db.models.signals import post_save
from django.contrib.sites.shortcuts import get_current_site
from django.core.mail import send_mail
from django.dispatch import receiver
from django.contrib.auth import get_user_model
User = get_user_model()
from allauth.account.utils import user_pk_to_url_str
from django.contrib.auth import get_user_model
from django.core.mail import send_mail
from django.utils.translation import gettext_lazy as _
from allauth.account.forms import EmailAwarePasswordResetTokenGenerator


@receiver(post_save, sender=User)
def create_user_profile(instance, created, **kwargs):
    """
    User profile post save signal for creating a object
    """
    if created:
        Profile.objects.create(user=instance,profImage=instance.photoUrl)

@receiver(email_confirmed)
def send_password_reset_email(sender, request, email_address, **kwargs):
    user = email_address.user
    if user.is_active:

        domain = get_current_site(request).domain

        token_generator = EmailAwarePasswordResetTokenGenerator()
        uid = user_pk_to_url_str(user)
        token = token_generator.make_token(user)

        reset_url = f"http://{domain}/account/password/reset/key/{uid}-{token}"

        # Customize the email subject and message
        subject = 'Account Verified and Logged In'
        message = f'Hi {user.username},\n\n' \
                  f'Your account has been verified .\n\n' \
                  f'<h1>You can reset your password to start using it</h1> : {reset_url}'

        # Send the email
        send_mail(subject, message, 'noreply@example.com', [user.email])

