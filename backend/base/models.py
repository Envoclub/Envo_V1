"""
All The Database Activity and Tables for the Login Application is written here
"""
from django.db import models
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager,User
from django.utils.translation import gettext_lazy as _
from django.core.validators import RegexValidator
from django.conf import settings

"""
This list are the type of users available on the application 
with inclusion of SUPER ADMIN
"""
USER_TYPE = (
    ("EMPLOYER", "Employer"),
    ("EMPLOYEES", "Employees"),   
)

# Directory maker
def user_directory_path(instance, filename):
    """
    Helper class function for saving the media in backend
    """
    # file will be uploaded to MEDIA_ROOT / user_<id>/<filename>
    return 'profilePic/{0}/{1}'.format(instance.pk, filename) 

class Company(models.Model):
    """
    This class is to create model of a company on SaaS 
    """
    name = models.CharField(max_length=100)
    description = models.TextField()
    address = models.CharField(max_length=200)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        """
        this function returns string of name when saved
        """
        return self.name


# Create your models here.
class CustomAccountManager(BaseUserManager):
    '''Custom Account manager for managing roles'''
    ordering = ('email',)

    def create_user(self, email, username, password, **other_fields):
        '''Defining and creating user function'''
        if not email:
            raise ValueError(_("Email Is Mandatory"))
        email = self.normalize_email(email)
        user = self.model(email=email, username=username, **other_fields)
        user.set_password(password)
        user.save()
        return user

    def create_superuser(self, email, password=None, **other_fields):
        '''Defining and creating superuser function'''
        other_fields.setdefault("is_staff", True)
        other_fields.setdefault("is_superuser", True)
        other_fields.setdefault("is_active", True)
        return self.create_user(email=email, password=password, **other_fields)

class User(AbstractBaseUser, PermissionsMixin):
    '''Adding custom user models and permission'''
    
    class Types(models.TextChoices):
        '''Creating Proxy types and giving choices'''
        EMPLOYEES = "EMPLOYEES", "Employees"
        EMPLOYER = "EMPLOYER", "Employer"

    type = models.CharField(_('Type'), max_length=50, choices=Types.choices, default=Types.EMPLOYEES)

    username = models.CharField(max_length=150,unique=False)
    email = models.EmailField(_('email address'), unique=True)
    phoneNumberRegex = RegexValidator(regex = r"^\+?1?\d{8,15}$")
    phone_number = models.CharField(validators = [phoneNumberRegex], max_length = 16 , null=True , blank=True)
    bio = models.CharField(max_length=500,default="I am awesome" , null=True , blank=True)
    photoUrl = models.ImageField(upload_to=user_directory_path, null=True , blank=True)
    company = models.ForeignKey(Company, on_delete=models.DO_NOTHING, related_name='employees',default=1)
    reward = models.BigIntegerField(default=0)
    Co2 = models.FloatField(default=0)
    Co2_assumption = models.FloatField(default=0)
    survey_completed = models.BooleanField(default=False)

    is_staff = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    
    # booking_history is not needed, as we can get this details by querying room details
    objects = CustomAccountManager()
    USERNAME_FIELD = "email"
    EMAIL_FIELD = "email"
    REQUIRED_FIELDS = ["username"]

    def __str__(self):
        '''Returning str function'''
        return f"{self.username}"

    def get_absolute_url(self):
        '''Reverse url for error 404'''
        return "/users/%i/" % (self.pk)
   

class ConcreteImplementor1(models.Manager):
    '''this is the manager for customer type role'''
    def get_queryset(self, *args, **kwargs):
        '''Returning querysets of proxy model customer'''
        return super().get_queryset(*args, **kwargs).filter(type=User.Types.EMPLOYEES)

    def save(self, *args, **kwargs):
        '''Overriding the save function '''
        if not self.pk:
            self.type = User.Types.EMPLOYEES
        return super().save(*args, **kwargs)


class ConcreteImplementor2(models.Manager):
    '''this is the manager for owner type role'''
    def get_queryset(self, *args, **kwargs):
        '''Returning querysets of proxy model Owner'''
        return super().get_queryset(*args, **kwargs).filter(type=User.Types.EMPLOYER)

    def save(self, *args, **kwargs):
        '''Overriding the save function '''
        if not self.pk:
            self.type = User.Types.EMPLOYER
        return super().save(*args, **kwargs)

class Employees(User):
    '''this is proxy model for customer for fast and async models'''
    objects = ConcreteImplementor1()

    class Meta:
        '''obligating meta as true'''
        proxy = True

class Employer(User):
    '''this is proxy model for Owner for fast and async models'''
    objects = ConcreteImplementor2()

    class Meta:
        '''obligating meta as true'''
        proxy = True

class Profile(models.Model):
    """
    This is Profile Model
    """
    user = models.OneToOneField(settings.AUTH_USER_MODEL,related_name='profile', on_delete=models.CASCADE)
    followers = models.ManyToManyField(settings.AUTH_USER_MODEL,related_name='followers',symmetrical=False,blank=True)
    following = models.ManyToManyField(settings.AUTH_USER_MODEL,related_name='following',symmetrical=False,blank=True)
    postcount = models.BigIntegerField(default=0)
    profImage = models.CharField(max_length=200)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)