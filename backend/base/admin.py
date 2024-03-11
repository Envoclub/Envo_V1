"""
All The Models for the admin access is registered here
"""
from django.contrib import admin
from .models import User as NewUser
from .models import Company
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from base.models import Profile

# Registering Profile model to the admin
admin.site.register(Profile)

# Register your models here.
class UserAdmin(BaseUserAdmin):
    '''Creating a custom user admin page'''
    fieldsets = (
        (None, {'fields': ('email','type','username','password', 'phone_number', 'bio','photoUrl','company','reward','Co2')}),
        ('Permissions', {'fields': (
            'is_active',
            'is_staff',
            'is_superuser',
            'groups',
            'user_permissions',
            
        )}),
    )
    add_fieldsets = (
        (
            None,
            {
                'classes': ('wide',),
                'fields': ('email','username', 'password1', 'password2','phone_number','bio','photoUrl','company','reward','Co2')
            }
        ),
    )

    list_display = ('pk','email' ,'username','is_staff', 'last_login','bio','phone_number','photoUrl','type','reward','Co2')
    list_filter = ('is_staff', 'is_superuser', 'is_active', 'groups')
    search_fields = ('email',)
    ordering = ('email',)
    filter_horizontal = ('groups', 'user_permissions')

admin.site.register(NewUser, UserAdmin)
admin.site.register(Company)
