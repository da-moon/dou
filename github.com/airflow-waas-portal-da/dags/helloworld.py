from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.models import Variable
from datetime import datetime, timedelta
from airflow.exceptions import AirflowException
import json
import psycopg2
from airflow.hooks.postgres_hook import PostgresHook
from airflow.models import BaseOperator
from airflow.utils.decorators import apply_defaults
from airflow.utils.trigger_rule import TriggerRule
from fewknow_airflow.operators import GithubOperator, SlackOperator, MSTeamsWebhookOperator, TerraformOperator, GithubOperator
from airflow.operators.subdag_operator import SubDagOperator
from airflow.models import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.http_operator import SimpleHttpOperator
from airflow.models import Variable
from airflow.models import BaseOperator
from airflow.utils.decorators import apply_defaults
from airflow.exceptions import AirflowException
import slack
import requests
import jira
from airflow.hooks.base_hook import BaseHook

default_args = {
    'owner': 'Sangeetha Gajam',
    #'depends_on_past': False,
    'email': ['sangeetha.gajam@digitalonus.com'],
    'email_on_failure': True,
    'email_on_retry': True,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    'start_date': datetime(2019, 8, 28),
    'tags': ['github'],
    'max_active_runs': 1,
    # 'queue': 'bash_queue',
    # 'pool': 'backfill',
    # 'priority_weight': 10,
    # 'end_date': datetime(2016, 1, 1),
}


with DAG('WaaS_Portal', default_args=default_args, schedule_interval=None) as dag:

    github_task = GithubOperator(
        task_id = "github_repo_creator", 
        name="github_repo_creator",
        login_token=Variable.get('github_api_token'),
        the_github_url='https://api.github.com/orgs',
        org='DigitalOnUs',
        repo_name='testA',
        max_active_runs= 1
    )    

    teams_task = MSTeamsWebhookOperator(
        task_id="teams_task",
        webhook_url=Variable.get("teams_webhook_url"),
        message='Creating organization and workspace in Terraform',
        summary='testing',
        subtitle='Demo',
        image="https://teamsnodesample.azurewebsites.net/static/img/image5.png",
        button_text="[placeholder button]",
        button_url="https://docs.microsoft.com/outlook/actionable-messages"
        # organization='digital-on-us' # uncomment to incorporate ADO into the Teams operator
    )

    t1 = TerraformOperator(
        task_id="create_organization",
        target="create_organization",
        token=Variable.get("terraform_api_token"),
        organization_name="DoU-TFE-test",
        email_address="sangeetha.gajam@digitalonus.com"
    )

    t2 = TerraformOperator(
        task_id="create_workspace",
        target="create_workspace",
        token=Variable.get("terraform_api_token"),
        organization_name="DoU-TFE-test",
        workspace_name="test",
        email_address="sangeetha.gajam@digitalonus.com"
    )

    slack_task = SlackOperator(
        task_id="slack_task",
        webhook_url=Variable.get("slack_webhook_url"),
        channel='#cne_solutions',
        username='Airflow',
        text='Organization and workspace created',
        icon_url='https://raw.githubusercontent.com/apache/airflow/master/airflow/www/static/pin_100.png'
    )


    s3_module = {
            "variables": {
                "aws_region": {
                    "default": "us-east-2"
                }
            },
            
            "providers": {
                "aws": {
                    "region": "${var.aws_region}",
                    "profile": "default",
                    "access_key": Variable.get("aws_access_key"),
                    "secret_key": Variable.get("aws_secret_key"),
                    "skip_get_ec2_platforms": True,
                    "skip_metadata_api_check": True,
                    "skip_region_validation": True,
                    "skip_credentials_validation": True,
                    "skip_requesting_account_id": True
                }
            },

            "modules": {
                "s3-bucket": {
                    "source": "terraform-aws-modules/s3-bucket/aws",
                    "version": "2.6.0"
                }
            }
        }

    t3 = TerraformOperator(
        task_id="create_run",
        target="create_run",
        token=Variable.get("terraform_api_token"),
        organization_name="DoU-TFE-test",
        workspace_name="test",
        config=s3_module,
        email_address="sangeetha.gajam@digitalonus.com"
    )

    sleep_terraform = BashOperator(
    task_id='sleep_terraform',
    bash_command='sleep 20',
    dag=dag
    )


    
    github_task >> teams_task >> t1 >> t2 >> slack_task >> t3 >> sleep_terraform

    