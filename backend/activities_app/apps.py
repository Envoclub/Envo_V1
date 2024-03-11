"""
All the Configuration for the Activities Application is written here
"""
from django.apps import AppConfig

class ActivitiesConfig(AppConfig):
    """
    Application Configuration
    """
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'activities_app'

    def ready(self):
        import activities_app.signals
    