"""
All the Configuration for the base of application is written here
"""
from django.apps import AppConfig

class BaseConfig(AppConfig):
    """
    Application Configuration
    """
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'base'

    def ready(self):
        """
        This is function for importing base signals to the application 
        """
        import base.signals
