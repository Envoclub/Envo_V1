"""
Django includes a “signal dispatcher” which helps decoupled applications
get notified when actions occur elsewhere in the framework.
In a nutshell, signals allow certain senders to notify
a set of receivers that some action has taken place.
Signal function for post and pre saving
"""
from django.db.models.signals import post_save
from django.contrib.auth import get_user_model
from django.dispatch import receiver
from base.models import Profile
from .models import Post
User = get_user_model()

@receiver(post_save, sender=Post)
def create_user_profile(instance, created,**kwargs):
    """
    User Cast for post creation with profile object
    """
    if created:
        try:
            user = instance.user
            points = instance.action.points
            carbon_emmision = instance.action.savedemmision
            user.Co2 += carbon_emmision
            user.reward += points
            user.save()
            prof = Profile.objects.get(user=instance.user)
            prof.postcount += 1
            prof.save()
        except:
            raise ValueError