# Generated by Django 4.0.4 on 2023-07-06 21:11

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('base', '0002_user_co2_assumption_alter_user_co2'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='survey_completed',
            field=models.BooleanField(default=False),
        ),
    ]
