"""
All the Configuration for the base of application is written here
"""
from django.apps import AppConfig

class GamificationAppConfig(AppConfig):
    """
    Application Configuration
    """
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'gamification_app'
