"""
This modules is to specify permissions for the views 
"""
from rest_framework.permissions import BasePermission

class IsCompanyOwner(BasePermission):
    """
    This permission is for specifying for employer and employee
    """
    def has_object_permission(self, request, view, obj):
        """
        function for objecting the permission
        """
        if request.user.type =='EMPLOYER' and not request.user.is_superuser:
            return True
        else:
            raise ValueError("You are not a Employer")
