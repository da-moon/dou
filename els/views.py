from django.shortcuts import render
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from django.template.defaultfilters import slugify
from django.shortcuts import redirect
from django.http import HttpResponseRedirect
from .forms import PersonForm
from .models import Person, ValueToChange
from main import views
import logging
import datetime
from .documents import PersonDocument
from HelloWorld import settings
from HelloWorld import utils
import os
import consul
import json
import hvac
import vault_cli
from vault12factor import \
    VaultCredentialProvider, \
    VaultAuth12Factor, \
    DjangoAutoRefreshDBCredentialsDict


def main_page(request):
    return redirect('/status/')

# Create your views here.


def add_person(request):
    post = []
    person_form = None

    if request.method == 'POST':
        form = PersonForm(request.POST)
        if form.is_valid():
            post = form.save(commit=False)
            post.slug = slugify(post.first_name)
            post.save()
            return redirect('/people/persons_list/')
        else:
            Debug.error('Invalid info to add a new person')
    else:
        person_form = PersonForm()
    return render(
        request,
        'persons/info/edit_person.html',
        {
            'post': post,
            'post_form': person_form,
            'edit': False,
        }
    )


def post_list(request, tag_slug=None):
    persons = Person.objects.all().order_by('-created')

    paginator = Paginator(persons, 10)  # 3 persons in each page
    page = request.GET.get('page')

    try:
        persons = paginator.page(page)
    except PageNotAnInteger:
        # If page is not an integer deliver the first page
        persons = paginator.page(1)
    except EmptyPage:
        # If page is out of range deliver last page of results
        persons = paginator.page(paginator.num_pages)

    if request.method == 'POST' and request.is_ajax():
        try:
            my_data = request.POST.get("id")
            logger.debug({'Found person', my_data})
            return JsonResponse({'status': 'Success', 'result': None})
        except person.DoesNotExist:
            logger.error({'status': 'Fail', 'msg': 'Object does not exist'})
            return JsonResponse({'status': 'Fail', 'msg': 'Object does not exist'})

    t = datetime.datetime.now().date()

    return render(request,
                  'persons/info/list.html',
                  {'page': page,
                   'persons': persons,
                   })


def person_search(request):
    q = request.GET.get('q')
    if q:
        people = list(PersonDocument.search().query('match', first_name=q))
        people += list(PersonDocument.search().query('match', last_name=q))
    else:
        people = ''
    print(f'Request info: {q}')
    return render(request, 'elasticsearch/search.html', {'people': people})


def write_number_db(request, add=None):

    conn = utils.set_connection()

    db_var = None
    conn.autocommit = True
    print("Contents of the Value table: ")
    print(db_var)
    try:
        val, t = ValueToChange.objects.get_or_create(val_name='waas_value')
    except Exception:
        val = ValueToChange.objects.filter(val_name="waas_value").first()
    if add != None:
        val.value += 1
        val.save()
        # print('Update records')
        # sql = "UPDATE ValueToChange SET val = val + 1 WHERE val_name = 'waas_value'"
        # cursor.execute(sql)
        # print("Table updated...... ")
        # print("Contents of the ValueToChange table after the update operation: ")
        # sql = '''SELECT * from ValueToChange'''
        # db_var=cursor.execute(sql)
        # db_var=cursor.fetchall()
        # print(db_var)
        # conn.commit()
        # conn.close()
    print(f'New value {val}')
    return render(request,
                  'persons/sample_rw_db.html',
                  {'name': val.val_name,
                   'num': val.value})
    # return render(request,
    #     'persons/sample_rw_db.html',
    #     {'name': db_var[0][0],
    #      'num': db_var[0][1]})


def read_number_db(request):
    conn = utils.set_connection()
    try:
        val, t = ValueToChange.objects.get_or_create(val_name='waas_value')
    except Exception:
        val = ValueToChange.objects.filter(val_name="waas_value").first()
    print(f'Current value {val}')
    # db_var = None
    # conn.autocommit = True
    # cursor = conn.cursor()
    # print("Contents of the Value table: ")
    # sql = '''SELECT * from ValueToChange'''
    # cursor.execute(sql)
    # db_var=cursor.fetchall()
    # conn.commit()
    # conn.close()
    return render(request,
                  'persons/sample_r_db.html',
                  {'name': val.val_name,
                   'num': val.value})
