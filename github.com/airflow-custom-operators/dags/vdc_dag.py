import os
from os import environ
import sys
from types import LambdaType
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
    # 'on_failure_callback': my_helper.on_failure,
    # 'on_success_callback': my_helper.on_success
}
with DAG("VDC-Onboarding-DAG", default_args=default_args, schedule_interval=None, catchup=False) as dag:

    # Get workspace on Airflow environment: DOU or Assurant
    get_workspace.set_variables()

    vdc_onboarding_payload = {
        "application_name" : "",
        "service_principal" : "",
        "subscription_name" : "",
        "environment" : "",
        "sdlc_envrionments" : [],
        "tfe_workspace_prefix" : "",
        "tfe_token_variable_group_name" : "",
        "ado_repo_name" : "",
        "ado_project" : "",
        "solution_architect" : "",
        "application_architect" : "",
        "technical_leader" : "",
        "team_members" : ["Nagesh Potluri", "Alex Milimnik"],
        "owners" : { 
            "Orchestration Team" : "Nagesh Polturi",    
            "Worksloads Team" : "Nagesh Polturi",       
            "IAM/Compliance Team" : "Nagesh Polturi",  
            "Network Team" : "Nagesh Polturi",         
            "Observability Team" : "Nagesh Polturi",  
            "App Team" : "Nagesh Polturi",           
            "IAC Team" : "Nagesh Polturi",              
            "CEP Team" : "Nagesh Polturi",               
            "ServiceNow Team" : "Nagesh Polturi"
        }
    }

###############################################
# [STEP 2] Architectural Review               #
###############################################
    # Create ADO Feature work item
    create_architectural_review_work_item = AzureDevOpsOperator(
        task_id='create_architectural_review_work_item',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='2',
        work_item_type='Feature',
        title='VDC Onboarding: Step 2 - Create Architectural Review',
        description='Review of architectural requirements and relate to SSM offerings (updated modules, create modules as needed).',
        # TODO: Instead of hard coding, work on getting this vaule to be dynamic.
        # owners=['Worksloads Team'] 
        owners=['Worksloads Team']
    )

    # Send Teams notification after Feature work item is created
    send_architectual_review_teams_notification_to_owners = MSTeamsWebhookOperator(
        task_id='send_architectual_review_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_architectural_review_work_item.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='New Architectural Review Needed',
        subtitle='There is a new ADO work item that needs review.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )

    # If Feature work item is closed, trigger next task
    check_if_architectural_review_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_if_architectural_review_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_architectural_review_work_item.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 2] Dependencies
    create_architectural_review_work_item >> send_architectual_review_teams_notification_to_owners >> check_if_architectural_review_work_item_is_closed


###############################################
# [STEP 3] App Subscription Creation          #
###############################################
    # Create ADO Feature work item
    create_app_subscription = AzureDevOpsOperator(
        task_id='create_app_subscription_work_item',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='3',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 3 - Create App Subscription',
        description='Query Azure subscriptions or resource groups to verify ESAM existence.',
        # TODO: Interpolate the previous ADO work item link here instead of going to Airflow UI
        owners=['IAM/Compliance Team']
        # application_name="Example Application Name"
        # environment=Development"
    )

    # Send Teams notification after Feature work item is created
    send_create_app_subscription_teams_notification_to_owners = MSTeamsWebhookOperator(
        task_id='send_create_app_subscription_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_app_subscription.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='Create Azure Application Subscription',
        subtitle='Use App Name & Environment to create a new App Subscription',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
        # owners=['TFE Team']# This owners value will determine which Teams channel to send this notification to.
    )

    # If Feature work item is closed, trigger next task
    check_if_create_app_subscription_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_if_create_app_subscription_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_app_subscription.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )
    
    # [STEP 3] Dependencies
    check_if_architectural_review_work_item_is_closed >> create_app_subscription >> send_create_app_subscription_teams_notification_to_owners >> check_if_create_app_subscription_work_item_is_closed


###############################################
# [STEP 4] TFE & Greenfield Team Onboarding   #
###############################################
    # Create ADO Feature work item
    create_greenfield_and_tfe_team_onboarding = AzureDevOpsOperator(
        task_id='create_greenfield_and_tfe_team_onboarding',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='4',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 4 - TFE & Greenfield Team Onboarding',
        description='Send automatic emails for Greenfield, Terraform & Datadog onboarding.',
        # TODO: owners=[vdc_onboarding_payload['owners'][2]
        owners=['IAM/Compliance Team']
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )

    # Send Teams notification after Feature work item is created 
    send_tfe_greenfield_onboarding_teams_notification_to_owners = MSTeamsWebhookOperator(
        task_id='send_tfe_greenfield_onboarding_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_greenfield_and_tfe_team_onboarding.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='Terraform Enterprise & Greenfield Onboarding Needed',
        subtitle='There is a new work item that requires TFE and Greenfield onboarding',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )

    # These TODOs are from Step 4 in confluence.assurant.com/display/aecpe/VDC_Onboarding+Orchestration
    # TODO: Send email for Greenfield, Terraform & Datadog onboarding document

    # If Feature work item is closed, trigger next task
    check_if_greenfield_and_tfe_team_onboarding_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_if_greenfield_and_tfe_team_onboarding_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_greenfield_and_tfe_team_onboarding.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 4] Dependencies
    check_if_create_app_subscription_work_item_is_closed >> create_greenfield_and_tfe_team_onboarding >> send_tfe_greenfield_onboarding_teams_notification_to_owners >> check_if_greenfield_and_tfe_team_onboarding_work_item_is_closed


###################################################
# [STEP 5] Spoke Creation for Each Environment    #
###################################################
    # Create ADO Feature work item
    create_spokes_for_each_environment = AzureDevOpsOperator(
        task_id='create_spokes_for_each_environment',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='5',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 5 - Create Spokes for Each Environment',
        description='Need to talk to Eric Jackson, Adam Melong, Vinay Venugopal to elaborate.',
        # TODO: owners=[vdc_onboarding_payload['owners'][2]
        owners=['Network Team']
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )

    # Send Teams notification after Feature work item is created 
    send_spokes_environments_teams_notification_to_owners = MSTeamsWebhookOperator(
        task_id='send_spokes_environments_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_spokes_for_each_environment.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='Spoke Creation for Each Environment Needed',
        subtitle='Inputs, Actions and Responses need to be determined',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )

    # If Feature work item is closed, trigger next task
    check_spoke_environment_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_spoke_environment_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_spokes_for_each_environment.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 5] Dependencies
    check_if_greenfield_and_tfe_team_onboarding_work_item_is_closed >> create_spokes_for_each_environment >> send_spokes_environments_teams_notification_to_owners >> check_spoke_environment_work_item_is_closed


#############################################################################
# [STEP 6] Centralize Log Analytics & Datadog Event Hub for Subscription    #
#############################################################################
    # Create ADO Feature work item
    create_centralized_log_analytics_datadog_event_hub_for_subscription = AzureDevOpsOperator(
        task_id='create_centralized_log_analytics_datadog_event_hub_for_subscription',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='6',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 6 - Create Centralized Log Analytics & Datadog Event Hub Subscription',
        description='Need to Subscription Name in order to create log analytics and Datadog eventhub. Response should be to update variables in application workspace for log analytics ID in workspace or Consul (TBD).',
        # TODO: owners=[vdc_onboarding_payload['owners'][2]
        owners=['Observability Team']
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )

    # Send Teams notification after Feature work item is created 
    send_log_analytics_datadog_event_hub_teams_notification_to_owners = MSTeamsWebhookOperator(
        task_id='send_log_analytics_datadog_event_hub_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_centralized_log_analytics_datadog_event_hub_for_subscription.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='Centralized Log Analytics & Datadog Event Hub Needed',
        subtitle='Need Subscription Name in order to create log analytics and Datadog eventhub.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )

    # If Feature work item is closed, trigger next task
    check_centralize_log_analytics_datadog_event_hub_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_centralize_log_analytics_datadog_event_hub_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_centralized_log_analytics_datadog_event_hub_for_subscription.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 6] Dependencies
    check_spoke_environment_work_item_is_closed >> create_centralized_log_analytics_datadog_event_hub_for_subscription >> send_log_analytics_datadog_event_hub_teams_notification_to_owners >> check_centralize_log_analytics_datadog_event_hub_work_item_is_closed


##########################################################
# [STEP 7] TFE Team Creation for Access to Workspaces    #
##########################################################
    # Create ADO Feature work item
    create_new_tfe_team = AzureDevOpsOperator(
        task_id='create_new_tfe_team',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='7',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 7 - Create TFE Team for Access to Workspaces',
        description='Airflow creates a team for developers and a team for pipeline integration, then team members recieve emails with workspace names as well as granted workspace access.',
        # TODO: owners=[vdc_onboarding_payload['owners'][2]
        owners=['Orchestration Team']
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )

    # Send Teams notification after Feature work item is created 
    send_tfe_team_workspace_access_teams_notification_to_owners = MSTeamsWebhookOperator(
        task_id='send_tfe_team_workspace_access_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_new_tfe_team.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='New TFE Team Needed',
        subtitle='Need Application Name and SDLC Environments for inputs, to create a TFE team for developers and a team for pipeline integration.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )

    # TODO: Create task that calls a TerraformEnterpriseOperator to create team workspace access
    # TODO: Send email to Team members after team workspace access has been granted.

    # TODO: Tehcnically this task below should not trigger until TFE team workspace access has been granted, then this Feature ticket can be closed and trigger this task
    # If Feature work item is closed, trigger next task
    check_new_tfe_team_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_new_tfe_team_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_new_tfe_team.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )
    
    # [STEP 7] Dependencies
    check_centralize_log_analytics_datadog_event_hub_work_item_is_closed >> create_new_tfe_team >> send_tfe_team_workspace_access_teams_notification_to_owners >> check_new_tfe_team_work_item_is_closed


###############################################################
# [STEP 8] TFE Team Creation for Access to each Envrionemnt   #
###############################################################
    # Create ADO Feature work item
    grant_tfe_team_enviornment_access = AzureDevOpsOperator(
        task_id='grant_tfe_team_enviornment_access',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='8',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 8 - Create TFE Team Environment Access',
        description='Airflow creates workspaces and grants permissions for the teams created in Step 7 to each TFE workspace environment.',
        # TODO: owners=[vdc_onboarding_payload['owners'][2]
        owners=['Orchestration Team']
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )

    # Send Teams notification after Feature work item is created 
    send_tfe_access_to_each_environment_teams_notification_to_owners = MSTeamsWebhookOperator(
        task_id='send_tfe_access_to_each_environment_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=grant_tfe_team_enviornment_access.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='TFE Team Workspace Environment Access Needed',
        subtitle='Need to create the workspaces for the new TFE Teams and grant it permissions to these workspaces for each environment.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )

    # TODO: Create task that calls a TerraformEnterpriseOperator to create team workspace access
    # TODO: Send email to Team members after team workspace access has been granted.

    # TODO: Tehcnically this task below should not trigger until TFE team workspace access has been granted, then this Feature ticket can be closed and trigger this task
    # If Feature work item is closed, trigger next task
    check_grant_tfe_team_environment_access_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_grant_tfe_team_environment_access_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=grant_tfe_team_enviornment_access.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )
    # [STEP 8] Dependencies
    check_new_tfe_team_work_item_is_closed >> grant_tfe_team_enviornment_access >> send_tfe_access_to_each_environment_teams_notification_to_owners >> check_grant_tfe_team_environment_access_work_item_is_closed


###############################################
# [STEP 9] Service Principal Creation         #
###############################################
    # Create ADO Feature work item
    create_service_principal = AzureDevOpsOperator(
        task_id='create_service_principal',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='9',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 9 - Create Service Principal',
        description='Airflow creates Service Principals using Terraform.',
        # TODO: owners=[vdc_onboarding_payload['owners'][2]
        owners=['Orchestration Team']
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )

    # Send Teams notification after Feature work item is created 
    send_service_principal_creation_teams_notification_to_owners = MSTeamsWebhookOperator(
        task_id='send_service_principal_creation_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_service_principal.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='Service Principal Creation Needed',
        subtitle='The Service Principal credentials are added to the TFE workspace.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )

    # If Feature work item is closed, trigger next task
    check_service_principal_creation_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_service_principal_creation_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_service_principal.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 9] Dependencies
    check_grant_tfe_team_environment_access_work_item_is_closed >> create_service_principal >> send_service_principal_creation_teams_notification_to_owners >> check_service_principal_creation_work_item_is_closed


##################################################
# [STEP 10] Tenant Datadog Dashboard Creation    #
##################################################
    # Create ADO Feature work item
    create_datadog_dashboard = AzureDevOpsOperator(
        task_id='create_datadog_dashboard',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='10',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 10 - Create Datadog Dashboard',
        description='Airflow creates the basic dashboard for the tenant.',
        # TODO: owners=[vdc_onboarding_payload['owners'][2]
        owners=['Observability Team']
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )   

    # Send Teams notification after Feature work item is created 
    send_datadog_dashboard_creation_teams_notification_to_owners=MSTeamsWebhookOperator(
        task_id='send_datadog_dashboard_creation_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_datadog_dashboard.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='Tenant Datadog Dashboard Needed',
        subtitle='Create a basic dashboard for the tenant using App Name, SDLC and Environments.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )

    # TODO: Create a task that calls the DatadogOperator to create a tenant dashboard
    # TODO: Send email to Team members after Airflow creates Datadog dashboard.

    # If Feature work item is closed, trigger next task
    check_datadog_dashboard_creation_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_datadog_dashboard_creation_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_datadog_dashboard.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 10] Dependencies
    check_service_principal_creation_work_item_is_closed >> create_datadog_dashboard >> send_datadog_dashboard_creation_teams_notification_to_owners >> check_datadog_dashboard_creation_work_item_is_closed


#################################################
# [STEP 11] Add Subscription to Logic Monitor   #
#################################################
    # Create ADO Feature work item
    add_azure_app_subscription_to_logic_monitor = AzureDevOpsOperator(
        task_id='add_azure_app_subscription_to_logic_monitor',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='11',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 11 - Add Azure App Subscription to Logic Monitor',
        description='Use subscription name to add to Logic Monitor Collector, then the Network Team will need to acknowledge & confirm this new addition has been made.',
        # TODO: owners=vdc_onboarding_payload['owners'][2]
        owners=['Network Team', 'CEP Team'] 
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )   

    # Send Teams notification after Feature work item is created 
    send_add_subscription_to_logic_monitor_teams_notification_to_owners=MSTeamsWebhookOperator(
        task_id='send_add_subscription_to_logic_monitor_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=add_azure_app_subscription_to_logic_monitor.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='Add Azure App Subscription to Logic Montior',
        subtitle='Network Team will need to acknowledge & confirm this new addition has been made.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )

    # If Feature work item is closed, trigger next task
    check_add_subscription_to_logic_monitor_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_add_subscription_to_logic_monitor_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=add_azure_app_subscription_to_logic_monitor.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 11] Dependencies
    check_datadog_dashboard_creation_work_item_is_closed >> add_azure_app_subscription_to_logic_monitor >> send_add_subscription_to_logic_monitor_teams_notification_to_owners >> check_add_subscription_to_logic_monitor_work_item_is_closed


###############################################
# [STEP 12] ADO Repo and Pipeline Creation    #
###############################################
    # Create ADO Feature work item
    create_ado_repo_and_pipeline = AzureDevOpsOperator(
        task_id='create_ado_repo_and_pipeline',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='12',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 12 - Create ADO Repo & Pipeline',
        description='IAC Team or Airflow to creates a respository and pipeline per the process based on standard contracts between teams.',
        # TODO: owners=vdc_onboarding_payload['owners'][2]
        owners=['App Team', 'IAC Team'] 
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )   

    # Send Teams notification after Feature work item is created 
    send_ado_repo_pipeline_creation_teams_notification_to_owners=MSTeamsWebhookOperator(
        task_id='send_ado_repo_pipeline_creation_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_ado_repo_and_pipeline.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='ADO Repo and Pipeline Creation Needed',
        subtitle='IAC Team needs to acknowledge the creation in Airflow.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )

    # If Feature work item is closed, trigger next task
    check_ado_repo_pipeline_creation_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_ado_repo_pipeline_creation_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_ado_repo_and_pipeline.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 12] Dependencies
    check_add_subscription_to_logic_monitor_work_item_is_closed >> create_ado_repo_and_pipeline >> send_ado_repo_pipeline_creation_teams_notification_to_owners >> check_ado_repo_pipeline_creation_work_item_is_closed


###############################################
# [STEP 13] ADO Pipeline TFE Integration      #
###############################################
    # Create ADO Feature work item
    create_ado_pipeline_tfe_integration = AzureDevOpsOperator(
        task_id='create_ado_pipeline_tfe_integration',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='13',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 13 - Create ADO Pipeline TFE Integration',
        description='ADO Repo and TFE Workspace are inputs. The action is for Airflow to generate the token and associate it in ADO.',
        # TODO: owners=vdc_onboarding_payload['owners'][2]
        owners=['App Team', 'IAC Team', 'CEP Team'] 
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )   

    # Send Teams notification after Feature work item is created 
    send_ado_pipeline_tfe_integration_teams_notification_to_owners=MSTeamsWebhookOperator(
        task_id='send_ado_pipeline_tfe_integration_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_ado_pipeline_tfe_integration.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='ADO Pipeline TFE Integration Needed',
        subtitle='Airflow generates token and associates it in ADO.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )

    # If Feature work item is closed, trigger next task
    check_ado_pipeline_tfe_integration_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_ado_pipeline_tfe_integration_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_ado_pipeline_tfe_integration.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 13] Dependencies
    check_ado_repo_pipeline_creation_work_item_is_closed >> create_ado_pipeline_tfe_integration >> send_ado_pipeline_tfe_integration_teams_notification_to_owners >> check_ado_pipeline_tfe_integration_work_item_is_closed


###############################################
# [STEP 14] ADO Service Endpoint              #
###############################################
    # Create ADO Feature work item
    create_ado_service_endpoint = AzureDevOpsOperator(
        task_id='create_ado_service_endpoint',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='14',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 14 - Create ADO Service Endpoint',
        description='Using ADO repo, Subscription and Service Principal create Service Endpoints for the pipeline template repo and the Azure Resource Manager.',
        # TODO: owners=vdc_onboarding_payload['owners'][2]
        owners=['App Team', 'IAC Team'] 
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )   

    # Send Teams notification after Feature work item is created 
    send_ado_service_endpoint_teams_notification_to_owners=MSTeamsWebhookOperator(
        task_id='send_ado_service_endpoint_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_ado_service_endpoint.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='ADO Service Endpoint Needed',
        subtitle='Using ADO repo, Subscription and Service Principal create Service Endpoints for the pipeline template repo and the Azure Resource Manager.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )

    # If Feature work item is closed, trigger next task
    check_ado_service_endpoint_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_ado_service_endpoint_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_ado_service_endpoint.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 14] Dependencies
    check_ado_pipeline_tfe_integration_work_item_is_closed >> create_ado_service_endpoint >> send_ado_service_endpoint_teams_notification_to_owners >> check_ado_service_endpoint_work_item_is_closed


###############################################
# [STEP 15] ADO Build Agent Deployment        #
###############################################
    # Create ADO Feature work item
    create_ado_build_agent_deployment = AzureDevOpsOperator(
        task_id='create_ado_build_agent_deployment',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='15',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 15 - Create ADO Build Agent Deployment',
        description='Using ADO repo, Subscription and Service Principal create Service Endpoints for the pipeline template repo and the Azure Resource Manager.',
        # TODO: owners=vdc_onboarding_payload['owners'][2]
        owners=['App Team', 'IAC Team']
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )   

    # Send Teams notification after Feature work item is created 
    send_ado_build_agent_deployment_teams_notification_to_owners=MSTeamsWebhookOperator(
        task_id='send_ado_build_agent_deployment_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_ado_build_agent_deployment.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='ADO Build Agent Deployment Needed',
        subtitle='Using ADO Project and Subscription; ADO build agent deployed as needed if shared cannot be consumed.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )

    # If Feature work item is closed, trigger next task
    check_ado_build_agent_deployment_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_ado_build_agent_deployment_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_ado_build_agent_deployment.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 15] Dependencies
    check_ado_service_endpoint_work_item_is_closed >> create_ado_build_agent_deployment >> send_ado_build_agent_deployment_teams_notification_to_owners >> check_ado_build_agent_deployment_work_item_is_closed


##################################################
# [STEP 16] ADO Datadog Service Hooks Creation   #
##################################################
    # Create ADO Feature work item
    create_ado_datadog_service_hooks = AzureDevOpsOperator(
        task_id='create_ado_datadog_service_hooks',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='16',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 16 - Create ADO-Datadog Service Hooks',
        description='Using ADO repo, Airflow creates service hooks into Datadog.',
        # TODO: owners=vdc_onboarding_payload['owners'][2]
        owners=['IAC Team', 'CEP Team']
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )   

    # Send Teams notification after Feature work item is created 
    send_ado_datadog_service_hooks_teams_notification_to_owners=MSTeamsWebhookOperator(
        task_id='send_ado_datadog_service_hooks_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_ado_datadog_service_hooks.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='ADO-Datadog Service Hooks Needed',
        subtitle='Using ADO repo, Airflow creates service hooks into Datadog.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    ) 

    # If Feature work item is closed, trigger next task
    check_ado_datadog_service_hooks_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_ado_datadog_service_hooks_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_ado_datadog_service_hooks.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 16] Dependencies
    check_ado_build_agent_deployment_work_item_is_closed >> create_ado_datadog_service_hooks >> send_ado_datadog_service_hooks_teams_notification_to_owners >> check_ado_datadog_service_hooks_work_item_is_closed


###############################################
# [STEP 17] Customer Domain Creation          #
###############################################
    # Create ADO Feature work item
    create_customer_domain = AzureDevOpsOperator(
        task_id='create_customer_domain',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='17',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 17 - Create Customer Domain',
        description='E-Prism, Greenfield.Assurant.com - TBD.',
        # TODO: owners=vdc_onboarding_payload['owners'][2]
        owners=['IAC Team', 'CEP Team']
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )   

    # Send Teams notification after Feature work item is created 
    send_create_customer_domain_teams_notification_to_owners=MSTeamsWebhookOperator(
        task_id='send_create_customer_domain_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_customer_domain.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='Customer Domain Needed',
        subtitle='E-Prism, Greenfield.Assurant.com - TBD.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    ) 

    # If Feature work item is closed, trigger next task
    check_create_customer_domain_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_create_customer_domain_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_customer_domain.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 17] Dependencies
    check_ado_datadog_service_hooks_work_item_is_closed >> create_customer_domain >> send_create_customer_domain_teams_notification_to_owners >> check_create_customer_domain_work_item_is_closed


###############################################
# [STEP 18] Vault Namespace Creation          #
###############################################
    # Create ADO Feature work item
    create_vault_namespace = AzureDevOpsOperator(
        task_id='create_vault_namespace',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='18',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 18 - Create Vault Namespace',
        description='Create Vault Namespace - TBD.',
        # TODO: owners=vdc_onboarding_payload['owners'][2]
        owners=['IAC Team', 'CEP Team']
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )   

    # Send Teams notification after Feature work item is created 
    send_create_vault_namespace_teams_notification_to_owners=MSTeamsWebhookOperator(
        task_id='send_create_vault_namespace_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_vault_namespace.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='Vault Namespace Needed',
        subtitle='Create Vault Namespace - TBD.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )  

    # If Feature work item is closed, trigger next task
    check_create_vault_namespace_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_create_vault_namespace_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_vault_namespace.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 18] Dependencies
    check_create_customer_domain_work_item_is_closed >> create_vault_namespace >> send_create_vault_namespace_teams_notification_to_owners >> check_create_vault_namespace_work_item_is_closed


###############################################
# [STEP 19] Consul Namespace Creation         #
###############################################
    # Create ADO Feature work item
    create_consul_namespace = AzureDevOpsOperator(
        task_id='create_consul_namespace',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='19',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 19 - Create Consul Namespace',
        description='Create Consul Namespace - TBD.',
        # TODO: owners=vdc_onboarding_payload['owners'][2]
        owners=['IAC Team', 'CEP Team']
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
    )   

    # Send Teams notification after Feature work item is created 
    send_create_consul_namespace_teams_notification_to_owners=MSTeamsWebhookOperator(
        task_id='send_create_consul_namespace_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_consul_namespace.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='Consul Namespace Needed',
        subtitle='Create Consul Namespace - TBD.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )  

    # If Feature work item is closed, trigger next task
    check_create_consul_namespace_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_create_consul_namespace_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_consul_namespace.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 19] Dependencies
    check_create_vault_namespace_work_item_is_closed >> create_consul_namespace >> send_create_consul_namespace_teams_notification_to_owners >> check_create_consul_namespace_work_item_is_closed


###############################################
# [STEP 20] ServiceNow Alert Configuration    #
###############################################
    # Create ADO Feature work item
    create_servicenow_alert_configuration = AzureDevOpsOperator(
        task_id='create_servicenow_alert_configuration',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        target='create_work_item',
        vdc_onboarding=True,
        step='20',
        work_item_type='Feature',
        # TODO: It could be removed if not needed
        title='VDC Onboarding: Step 20 - Create ServiceNow Alert Configuration',
        description='App Name and Environment is needed so Airflow can email the Confluence page with alert formats, so application teams can work with ServiceNow team to configure alerts.',
        # TODO: owners=vdc_onboarding_payload['owners'][2]
        owners=['ServiceNow Team']
        # team_members=['Nagesh Potluri', 'Alex Milimnik']
        # application_name="Example Application Name",
        # environment="Development"
    )   

    # Send Teams notification after Feature work item is created 
    send_create_servicenow_alert_configuration_teams_notification_to_owners=MSTeamsWebhookOperator(
        task_id='send_create_servicenow_alert_configuration_teams_notification_to_owners',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        previous_task_id=create_servicenow_alert_configuration.task_id,
        theme_color="0076D7",
        summary='Airflow Teams Operator',
        message='ServiceNow Alert Configuration Needed',
        subtitle='App Name and Environment is needed so Airflow can email the Confluence page with alert formats, so application teams can work with ServiceNow team to configure alerts.',
        image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
    )  

    # If Feature work item is closed, trigger next task
    check_create_servicenow_alert_configuration_work_item_is_closed = AzureDevOpsOperator(
        task_id='check_create_servicenow_alert_configuration_work_item_is_closed',
        token=get_workspace.set_variables.ADO_TOKEN,
        organization=get_workspace.set_variables.ORGANIZATION_NAME,
        project=get_workspace.set_variables.TEAM_PROJECT,
        get_inputs_from=create_servicenow_alert_configuration.task_id,
        check_state=True,
        target="get_work_item_by_id"
    )

    # [STEP 20] Dependencies
    check_create_consul_namespace_work_item_is_closed >> create_servicenow_alert_configuration >> send_create_servicenow_alert_configuration_teams_notification_to_owners >> check_create_servicenow_alert_configuration_work_item_is_closed