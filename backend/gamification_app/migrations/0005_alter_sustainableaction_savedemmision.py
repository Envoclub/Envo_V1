# Generated by Django 4.0.4 on 2023-09-22 09:54

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gamification_app', '0004_alter_rewards_company'),
    ]

    operations = [
        migrations.AlterField(
            model_name='sustainableaction',
            name='savedemmision',
            field=models.FloatField(default=0),
        ),
    ]