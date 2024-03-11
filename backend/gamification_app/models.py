"""
All The Database Activity and Tables for the gamification Application is written here
"""
from django.db import models
from base.models import Company

class SustainableActionCategory(models.Model):
    """
    This class has a model for categories of sustainable action
    """
    name = models.CharField(max_length=100)

    def __str__(self):
        """
        This returns the string of name
        """
        return self.name
# # Create your models here.
class SustainableAction(models.Model):
    """
    This class has a model for all the sustainable actions
    """
    action = models.CharField(max_length=100)
    description = models.CharField(max_length=200)
    points = models.PositiveIntegerField()
    impact = models.CharField(max_length=200)
    category = models.ForeignKey(SustainableActionCategory, on_delete=models.CASCADE)
    savedemmision = models.IntegerField(default=0)
    color = models.CharField(max_length=11)
    image = models.ImageField(upload_to='sustainable_action_images/', null=True, blank=True)

    def __str__(self):
        """
        This returns the string of action
        """
        return self.action
    
class Rewards(models.Model):
    """
    This class has a model for all the Rewards given
    """
    company = models.ForeignKey(Company,on_delete=models.DO_NOTHING,default=1)
    banner = models.URLField(null=True, blank=True)
    title = models.CharField(max_length=500)
    description = models.CharField(max_length=100)
    coinrequired = models.BigIntegerField()
    redeemed_count = models.PositiveIntegerField(default=0)