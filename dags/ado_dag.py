import os
from os import environ
import sys
sys.path.insert(1,'/home/airflow/')
sys.path.insert(1,'/usr/local/airflow/')
from airflow.exceptions import AirflowException
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta
from airflow.operators.python_operator import PythonOperator
from libraries.ado_operator import AzureDevOpsOperator
from libraries.teams_operator import MSTeamsWebhookOperator
from libraries import helpers as my_helper
from libraries import get_workspace
from airflow.models import Variable


default_args = {
    "owner": "DOU-DevOps",
    "depends_on_past": False,
    "start_date": datetime(2015, 6, 1),
    'provide_context': True,
    "email": ["airflow@airflow.com"],
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}
with DAG("ADO-Examples-DAG", default_args=default_args, schedule_interval=None, catchup=False) as dag:

    # Get workspace on Airflow environment: DOU or Assurant
    get_workspace.set_variables()
    
    # Creating a work item query. ***Todo: Migrate to Helpers or Operators
    '''
    my_helper.create_a_query() has those parameters
        select_query   : List or str (Optional)
        from_query     : List or str (Optional)
        where_query    : List or str (If it is str, you need to put AND/OR manually) (Optional)
        where_type     : List or str (If you assign a list for where_query, you need to assign "AND" or "OR" to this parameter) (Optional)
        order_by_query : List or str (Optional)
        type_of_order  : List or str (Optional)
    '''
    SELECT_ITEMS = ['[System.Title]', '[System.State]', '[System.AreaPath]', '[System.IterationPath]']
    FROM_ITEMS = "WorkItems"    
    WHERE_ITEMS = "[System.TeamProject]='{teamProject}' AND [System.WorkItemType]='{workItemType}'".format(teamProject = get_workspace.set_variables.TEAM_PROJECT, workItemType = get_workspace.set_variables.WORK_ITEM_TYPE)
    ORDER_BY_ITEMS = "[System.ChangedDate]"
    ORDER_TYPE = "DESC"
    full_query = my_helper.create_a_query(select_query=SELECT_ITEMS, from_query=FROM_ITEMS, where_query=WHERE_ITEMS, order_by_query=ORDER_BY_ITEMS, type_of_order=ORDER_TYPE)

    # # Tasks in the DAG.
    # t1 = BashOperator(
    #     task_id='ado_curl_projects',
    #     bash_command='curl --silent \
    #         -H "Accept: application/json" \
    #         -H "Authorization: Basic {tokenBase64}" \
    #         -H "Content-Type: application/json" \
    #         https://dev.azure.com/{organizationName}/_apis/projects\?api-version\=5.1'.format(organizationName = get_workspace.set_variables.ORGANIZATION_NAME.replace(" ", "%20"), tokenBase64 = get_workspace.set_variables.token_base64),
    #     retries=3
    # )
    # t2 = BashOperator(
    #     task_id='ado_curl_work_item_with_id',
    #     bash_command='''curl --silent \
    #         -H "Accept: application/json" \
    #         -H "Authorization: Basic {tokenBase64}" \
    #         -H "Content-Type: application/json" \
    #         https://dev.azure.com/{organizationName}/{teamProject}/_apis/wit/workitems/{workItemId}?api-version=6.0 | python -c "import sys, json; obj=json.load(sys.stdin);print([i for i in obj['fields'].values()])"'''.format(organizationName = get_workspace.set_variables.ORGANIZATION_NAME.replace(" ", "%20"), tokenBase64 = get_workspace.set_variables.token_base64, teamProject = get_workspace.set_variables.TEAM_PROJECT.replace(" ", "%20"), workItemId = get_workspace.set_variables.WORK_ITEM_ID),
    #     retries=3
    # )
    # t3 = BashOperator(
    #     task_id='ado_curl_team_backlog',
    #     bash_command='curl --silent \
    #         -H "Accept: application/json" \
    #         -H "Authorization: Basic {tokenBase64}" \
    #         -H "Content-Type: application/json" \
    #         https://dev.azure.com/{organizationName}/{teamProject}/{backlogTeamName}/_apis/work/backlogs?api-version=6.0-preview.1'.format(organizationName = get_workspace.set_variables.ORGANIZATION_NAME.replace(" ", "%20"), tokenBase64 = get_workspace.set_variables.token_base64, teamProject = get_workspace.set_variables.TEAM_PROJECT.replace(" ", "%20"), backlogTeamName = get_workspace.set_variables.BACKLOG_TEAM_NAME.replace(" ", "%20")),
    #     retries=3
    # )
    # t4 = AzureDevOpsOperator(task_id='ado_operator',
    #     token=get_workspace.set_variables.ADO_TOKEN,
    #     query=full_query,
    #     organization=get_workspace.set_variables.ORGANIZATION_NAME, 
    #     target = "Wiql"
    # )
    t5 = AzureDevOpsOperator(
        task_id='create_ado_work_item',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target="create_work_item",
        work_item_type=get_workspace.set_variables.WORK_ITEM_TYPE,
        title=get_workspace.set_variables.WORK_ITEM_TITLE,
        check_state=True
        # tags=WORK_ITEM_TAGS,
        # assigned_to="Selman Petek"
    )
    t5_check_state = AzureDevOpsOperator(
        task_id='check_work_item_state_if_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=t5.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )
    # t6 = AzureDevOpsOperator(
    #     task_id='if_target_is_empty',
    #     token=get_workspace.set_variables.ADO_TOKEN,
    #     organization=get_workspace.set_variables.ORGANIZATION_NAME,
    #     project=get_workspace.set_variables.TEAM_PROJECT,
    #     id=get_workspace.set_variables.WORK_ITEM_ID
    # )
    # t7 = AzureDevOpsOperator(
    #     task_id='get_single_work_item',
    #     token=get_workspace.set_variables.ADO_TOKEN,
    #     organization=get_workspace.set_variables.ORGANIZATION_NAME,
    #     project=get_workspace.set_variables.TEAM_PROJECT,
    #     id=get_workspace.set_variables.WORK_ITEM_ID,
    #     target="get_work_item_by_id"
    # )
    # t8 = MSTeamsWebhookOperator(
    #     task_id='my_first_teams_task',
    #     webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
    #     theme_color = "0076D7",
    #     summary='Airflow Teams Operator',
    #     message='Teams Notifications',
    #     subtitle = "Notification Test",
    #     image = 'https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
    #     button_text = "View DAG",
    #     button_url = get_workspace.set_variables.AIRFLOW_UI_URL,
    # )
    # TODO: Send Teams notifications on success/failure of ADO ticket creation
    # def on_success(context):
    #     print("OK callback")

    #     for i in context.items():
    #         print(i)
    #     t9 = MSTeamsWebhookHook(
    #         task_id='my_first_teams_hook_task',
    #         http_con_id='teams_connection',
    #         webhook_token=os.environ['TEAMS_WEBHOOK_URL'],
    #         message='Hello world!'
    #     )
    #     t9.execute(context)
    
    # # Dependencies.
    # t2.set_upstream(t1)
    # t3.set_upstream(t2)
    # t4.set_upstream(t3)
    t5 >> t5_check_state #>> t6 >> t7 >> t8
