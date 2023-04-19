from django.conf import settings
from django.db import models
from django.utils import timezone
from django.urls import reverse
import datetime

# Esta clase contiene la información necesaria para crear un post del blog


class Person(models.Model):
    STATUS_CHOICES = (('male', 'Male'),
                      ('female', 'Female'))

    first_name = models.CharField(max_length=250)

    last_name = models.CharField(max_length=250)

    #slug = models.SlugField(max_length=250)
    job_description = models.TextField(verbose_name="", null=True)

    publish = models.DateTimeField(default=timezone.now)

    created = models.DateTimeField(default=timezone.now)

    updated = models.DateTimeField(default=timezone.now)

    gender = models.CharField(max_length=10,
                              choices=STATUS_CHOICES,
                              default='male')

    def get_absolute_image_url(self):
        return 'profile_image/profile-circle.png'

    class Meta:
        ordering = ('-publish',)

        def __str__(self):
            return self.title


class ValueToChange(models.Model):
    val_name = models.CharField(max_length=250)
    value = models.IntegerField(default=0)
