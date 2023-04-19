import sys
sys.path.insert(1,'/usr/local/airflow')
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.models import Variable
from datetime import datetime, timedelta
from airflow.exceptions import AirflowException
import json
import psycopg2
import os
from airflow.hooks.postgres_hook import PostgresHook
from airflow.models import BaseOperator
from airflow.utils.decorators import apply_defaults
from airflow.utils.trigger_rule import TriggerRule


def create_dag(dag_id):

    dag = DAG(dag_id,
              schedule_interval=cron_schedule,
              default_args=default_args,
              catchup=False)

    # meta_data={"TENANT": tenant , "ENDPOINT": endpoint , "TIMESTAMP": time, "JOB_TYPE" : job_type, "JOB_NAME" : job_name}
    # with dag:
    #     t1 = NomadOperator(
    #             task_id=schedule_name,
    #             job="enterprise_scheduler",
    #             meta=json.dumps(meta_data),
    #             sleep_amount=1,
    #             nomad_host="nomad.{env}.fewknow.net".format(env=os.environ['ENVIRONMENT']),
    #         )

    return dag


# scheduler = Helpers()
# tenants = scheduler.get_children_keys(consul_key='config/scheduler/', host=os.environ['CONSUL'])
# for tenant_keys in tenants:
#     keys=tenant_keys.split('/')
#     tenant=keys[2]
#     key=tenant_keys + "jobs/"
#     schedules = scheduler.get_schedules(consul_key=key, host=os.environ['CONSUL'])
#     for schedule in schedules:
#         dict_schedule=json.loads(schedule)
#         job_name = dict_schedule['job_name']
#         options = dict_schedule['options']
#         #THIS IS NEEDED AFTER WE KNOW THE OPTIONS
#         #cron_schedule = scheduler.get_option_schedule(dict_schedule['schedule'], options)
#         cron_schedule = dict_schedule['schedule']
#         endpoint = dict_schedule['endpoint']
#         job_type = dict_schedule['job_type']
#         schedule_name = tenant + "_" + job_name

#         print("SCHEDULE")
#         print(job_name)
#         print(schedule)
#         print(schedule_name)
#         print(cron_schedule)
#         print(endpoint)
#         print(options)
#         print(job_type)
#         time = datetime.utcnow().isoformat()
#         dag_id = 'schedule_{s}'.format(s=schedule_name)

#         default_args = {'owner': 'enterprise_scheduler',
#                         'start_date': datetime(2018, 1, 1),
#                         'email': ['devops@digitalonus.com'],
#                         'email_on_failure': True,
#                         'email_on_retry': True,
#                         'retries': 1,
#                         'retry_delay': timedelta(minutes=5),
#                         }


#         globals()[dag_id] = create_dag(dag_id,
#                                       cron_schedule,
#                                       schedule_name,
#                                       tenant,
#                                       endpoint,
#                                       time,
#                                       job_type,
#                                       job_name,
#                                       default_args)
