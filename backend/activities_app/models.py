"""
All The Database Activity and Tables for the Activities Application is written here
"""
from django.db import models
from django.conf import settings
from gamification_app.models import SustainableAction

def user_directory_path(instance, filename):
    """
	User directory for describing the path
	"""
    return f'Posts/{instance.user.pk}/{filename}'

class Post(models.Model):
	"""
	Post Models
	"""
	user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
	description = models.CharField(max_length=255, blank=True)
	postUrl = models.FileField(upload_to=user_directory_path)
	likes = models.ManyToManyField(settings.AUTH_USER_MODEL,related_name='like',
									default=None,blank=True)
	like_count = models.BigIntegerField(default=0)
	date_posted = models.DateTimeField(auto_now_add=True)
	tags = models.CharField(max_length=100, blank=True)
	action = models.ForeignKey(SustainableAction,on_delete=models.DO_NOTHING)
	active = models.BooleanField(default=True)

	def __str__(self):
		"""
		function for returning string on admin 
		"""
		if self.user.username:
			return f"{self.user.username} Posts"

	@property
	def username(self):
		"""
		Property for returning username of the user
		"""
		return self.user.username

	@property
	def photoUrl(self):
		"""
		Property for returning profile pic of the user
		"""
		return self.user.photoUrl.url