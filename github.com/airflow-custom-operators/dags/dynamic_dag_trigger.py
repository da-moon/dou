import sys
sys.path.insert(1,'/home/airflow/')
sys.path.insert(1,'/usr/local/airflow/')
from datetime import datetime, timedelta
from airflow import DAG
from libraries.ado_operator import AzureDevOpsOperator
from libraries import get_workspace

default_args = {
        'owner': 'DOU-DevOps',
        'start_date': datetime(2018, 1, 1),
        # 'email': ['devops@digitalonus.com'],
        # 'email_on_failure': True,
        # 'email_on_retry': True,
        'retries': 1,
        'retry_delay': timedelta(minutes=1),
    }
    
get_workspace.set_variables()

with DAG('DYNAMIC-DAGS-TRIGGER',
        schedule_interval='* * * * *', # set to 1 min interval for testing
        default_args=default_args,
        catchup=False,
        is_paused_upon_creation=True) as dag:

            # Create Parent EPIC work item
        get_work_item_by_tag = AzureDevOpsOperator(
            task_id='get_work_item_by_tag',
            token=get_workspace.set_variables.ADO_TOKEN,
            organization=get_workspace.set_variables.ORGANIZATION_NAME, 
            project=get_workspace.set_variables.TEAM_PROJECT,
            target = "query_by_tag",
            tags = ['workloads_adoption', 'new_feature'],
            work_item_type='Epic'
        )
