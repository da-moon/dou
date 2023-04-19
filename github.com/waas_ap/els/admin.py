from django.contrib import admin
from .models import Person
from django import template

register = template.Library()

@admin.register(Person)
class PersonAdmin(admin.ModelAdmin):
    list_display = ('first_name', 'last_name', 'job_description', 'gender')
    list_filter = ('first_name', 'created', 'publish', 'gender')
    search_fields = ('first_name', 'gender')
    date_hierarchy = 'publish'
    ordering = ('gender', 'publish')