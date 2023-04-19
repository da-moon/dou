from django.shortcuts import render
import logging
from els import views
from HelloWorld import utils
from HelloWorld import settings
from els.models import ValueToChange
from django.http import HttpResponse


logger = logging.getLogger(__name__)


def hello_world(request):
    logger.debug('Enter in dashboard')
    logger.warning('Enter in dashboard warning')
    logger.error('Enter in dashboard error')

    conn = utils.set_connection()
    
    return render(request,
          'hello_world.html',
          ) 
   
    # db_var = None
    # conn.autocommit = True
    # cursor = conn.cursor()
    # print("Contents of the Value table: ")
    # sql = '''SELECT * from ValueToChange'''
    # cursor.execute(sql)
    # db_var=cursor.fetchall()
    # conn.commit()
    # conn.close()

# return render(request,
#         'hello_world.html',
#         {'name': db_var[0][0],
#          'num': db_var[0][1]})

def health_check(request):
    return HttpResponse('<h1>Page was found</h1>', status=200)