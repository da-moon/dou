from elasticsearch_dsl import analyzer
from django_elasticsearch_dsl import Document, Index, fields
from els.models import Person
from django_elasticsearch_dsl.registries import registry

persons = Index('els')

@registry.register_document
class PersonDocument(Document):
    class Django:
        model = Person
        index = 'person'
        fields = [
            'gender',
            'first_name',
            'last_name',
        ]
    class Index:
        name = "person"