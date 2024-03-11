"""
All The Models for the admin access is registered here
"""
from django.contrib import admin
from .models import SustainableActionCategory,SustainableAction,Rewards

# Register your models here.
admin.site.register(SustainableActionCategory)
admin.site.register(SustainableAction)
admin.site.register(Rewards)
