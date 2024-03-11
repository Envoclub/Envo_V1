"""
This is a validation class for all the validation
"""
from rest_framework import serializers
from .models import User

def validate_phone(value):
        """
        This is function for validating the phone number
        """
        qs = User.objects.filter(phone_number=value).exists()
        if qs:
            raise serializers.ValidationError(f"Same phone_number exists")
        return value