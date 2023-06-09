# Generated by Django 3.2.6 on 2021-09-12 21:43

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('els', '0002_valuetochange'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='person',
            name='icon',
        ),
        migrations.AlterField(
            model_name='person',
            name='id',
            field=models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID'),
        ),
        migrations.AlterField(
            model_name='valuetochange',
            name='id',
            field=models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID'),
        ),
        migrations.AlterField(
            model_name='valuetochange',
            name='value',
            field=models.IntegerField(default=0),
        ),
    ]
