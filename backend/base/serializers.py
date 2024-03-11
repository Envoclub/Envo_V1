"""
Serializers allow complex data such as querysets and model instances
to be converted to native Python datatypes that can then be easily rendered into JSON , 
"""
from rest_framework import serializers
from dj_rest_auth.registration.serializers import RegisterSerializer
from .validators import validate_phone
from .models import Company
from django.contrib.auth import get_user_model
User = get_user_model()

class CustomUserCreateSerializer(RegisterSerializer):
    companyName = serializers.SerializerMethodField()

    class Meta:
        model = User  # Replace 'User' with your user model class
        fields = ('id', 'email', 'username', 'password', 'company', 'companyName', 'survey_completed')

    def get_companyName(self, obj):
        return obj.company.name

    def get_companyName(self,obj):
        """
        this function is for getting company name
        """
        return obj.company.name

class CustomUserDetailSerializer(serializers.ModelSerializer):
    """
    serialization for User model in the login 
    """
    companyName = serializers.SerializerMethodField()
    class Meta:
        """
        Creating a meta class for logging in the user model 
        """
        model = User
        fields = ['username','email','phone_number','bio','photoUrl','survey_completed','company','companyName']
        read_only_fields = ('email',)

    def get_companyName(self,obj):
        """
        this function is for getting company name
        """
        return obj.company.name

class CustomRegisterSerializer(RegisterSerializer):
    """
    Serialization for authentication
    """
    username = serializers.CharField(required=True)
    email = serializers.EmailField(required=True)
    bio = serializers.CharField(default="I am awesome")
    password1 = serializers.CharField(required=True)
    password2 = serializers.CharField(required=True)
    company = serializers.PrimaryKeyRelatedField(
        queryset=Company.objects.all(),
        required=True
    )
    type = serializers.CharField(max_length=200,default="EMPLOYEES")

    class Meta:
        """
        Creating a meta class for storing the user details 
        """
        model = User
        fields = ['username','email','bio','password','survey_completed']

    
    def get_cleaned_data(self):
        """
        Created a function for cleaning the data
        for storing the user details
        """
        super(CustomRegisterSerializer,self).get_cleaned_data()
        
        return {
            'username': self.validated_data.get('username', ''),
            'email': self.validated_data.get('email', ''),
            'bio': self.validated_data.get('bio', ''),
            'password1': self.validated_data.get('password1', ''),
            'password2': self.validated_data.get('password2', ''),
            'type':self.validated_data.get('type', ''),
            'company': self.validated_data.get('company', None)
        }

    def save(self, request,*args, **kwargs):
        """
        Created a function for saving the user
        """
        try:
            user = super(CustomRegisterSerializer,self).save(request)
            user.username = self.cleaned_data.get('username')
            user.email = self.cleaned_data.get('email')
            user.bio = self.cleaned_data.get('bio')
            user.company = self.cleaned_data.get('company', None)
            user.type = self.cleaned_data.get('type')
            user.save()
            return user
        except ValueError:
            raise ValueError
            
class ProfileSerializer(serializers.ModelSerializer):
    """
    Serialization for followers and following in the application
    """
    post_count = serializers.SerializerMethodField(read_only=True)
    companyName = serializers.SerializerMethodField()
    class Meta:
        """
        Creating a meta class for displaying profile of the user
        """
        model = User
        fields = ['id','username','bio','photoUrl','post_count','email','phone_number','Co2','reward','type','survey_completed','company','companyName']
        
    def get_post_count(self,obj):
        """
        this is function for getting the postcount 
        """
        print(obj.profile.postcount)
        return obj.profile.postcount
    
    def get_companyName(self,obj):
        """
        this function is for getting company name
        """
        return obj.company.name
        
class CompanySerializer(serializers.ModelSerializer):
    """
    This is Company 
    """
    class Meta:
        model = Company
        fields = '__all__'