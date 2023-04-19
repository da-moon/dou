from django import forms
from .models import Person


class PersonForm(forms.ModelForm):
    class Meta:
        model = Person
        fields = (
            'first_name',
            'last_name',
            'gender',
            'job_description',
        )

        # labels = {
        #     'title': 'Título',
        #     'body': 'Cuerpo',
        #     'status': 'Estado',
        # }
