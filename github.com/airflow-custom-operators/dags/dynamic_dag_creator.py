import sys
sys.path.insert(1,'/home/airflow/')
sys.path.insert(1,'/usr/local/airflow/')
from airflow.exceptions import AirflowException
from airflow import DAG
from airflow.utils.db import provide_session
from airflow.models import XCom
from datetime import datetime, timedelta
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from libraries.ado_operator import AzureDevOpsOperator
from libraries.teams_operator import MSTeamsWebhookOperator
from airflow.models import Variable
from libraries import get_workspace
from libraries import helpers as my_helper
from airflow.operators.dagrun_operator import TriggerDagRunOperator

# TESTING PURPOSE
import pprint as pp
import json
import base64
import requests

# Get workspace on Airflow environment: DOU or Assurant
get_workspace.set_variables()


def create_dag(dag_id,
            cron_schedule,
            default_args,
            work_item_id,
            onboarding_type_var_name,
            work_item_count,
            project=None,
            title=None,
            id=None,
            state=None,
            token=None,
            query=None,
            target=None,
            organization=None,
            work_item_type=None,
            description=None,
            assigned_to=None,
            area=None,
            iteration=None,
            reason=None,
            discussion=None,
            fields=None,
            tags=None,
            destroy=False,):

    @provide_session
    def cleanup_xcom_and_vars(context, session=None):
        dag_id = context['dag_run'].dag_id
        # Clean up XComs
        session.query(XCom).filter(XCom.dag_id == dag_id).delete()
        # Clean up Variables
        Variable.delete(onboarding_type_var_name)
        Variable.delete("WORK_ITEM_ID_{}".format(work_item_count))
        Variable.delete("WORKLOADS_ADOPTION_REQUEST_{}".format(work_item_id))


    with DAG(dag_id,
            schedule_interval=cron_schedule,
            default_args=default_args,
            catchup=False,
            on_success_callback=cleanup_xcom_and_vars,
            # on_failure_callback=cleanup_xcom_and_vars,
            is_paused_upon_creation=False) as dag:

        # Get Airflow variable value
        onboarding_type = Variable.get(onboarding_type_var_name, default_var="default")

        # if ADO ticket tag contains 'workloads_adoption' - EPIC: this ticket stays open until this entire process is complete.
        if onboarding_type is not None and onboarding_type.lower() == "workloads_adoption":

            # Mark caught Epic work item as Active to aviod of reprocessing same Epic work item.
            mark_epic_work_item_active = AzureDevOpsOperator(
                task_id='mark_epic_work_item_active',
                token=get_workspace.set_variables.ADO_TOKEN,
                organization=get_workspace.set_variables.ORGANIZATION_NAME,
                project=get_workspace.set_variables.TEAM_PROJECT,
                target='update_work_item',
                id=work_item_id,
                state='Active'
            )
        
            #####################################
            # [STEP 1] Request                  #
            #####################################

            # ASSUMPTIONS: CEP teams always adds a tag to this work item after determining approved or denied: 'request_denied' or 'request_approved'

            # Create ADO work item that tells CEP to schedule an onboarding meeting with the requestor.
            # Requestor manually schedules a meeting in Teams,
            # this ticket remains open until the request is denied or approved by CEP adding either 'request_denied' or 'request_approved' tag to this work itm.
            # TASK - linked to parent FEATURE or EPIC
            create_workloads_adoption_request = AzureDevOpsOperator(
                task_id='Request',
                token=get_workspace.set_variables.ADO_TOKEN,
                organization=get_workspace.set_variables.ORGANIZATION_NAME,
                project=get_workspace.set_variables.TEAM_PROJECT,
                target="create_work_item",
                get_inputs_from=mark_epic_work_item_active.task_id,
                work_item_type="Feature",
                tags=onboarding_type,
                title="[Epic {}]: Workloads Adoption Process Teams Meeting Request".format(work_item_id)
            )

            # Send Teams notifications to CEP Teams Channel referencing this work item
            send_workloads_adoption_request_teams_notification_to_owners = MSTeamsWebhookOperator(
                task_id='send_workloads_adoption_request_teams_notification_to_owners',
                webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                organization=get_workspace.set_variables.ORGANIZATION_NAME,
                previous_task_id=create_workloads_adoption_request.task_id,
                theme_color="0076D7",
                summary='A new Workloads Adoption request has been made to the CEP Team',
                message='Workloads Adoption: Request',
                subtitle="If you want to deny the Request, then attach 'request_denied' tag to this work item, and mark the work item as closed. Otherwise it will accept the meeting by default, once you mark the work item as closed.",
                image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
            )
            
            # If this work item ticket above is 'request_denied' then ticket is closed and nothing else happens.
            check_and_close_if_work_item_is_approved_or_denied = AzureDevOpsOperator(
                task_id='check_and_close_if_work_item_is_approved_or_denied',
                token=get_workspace.set_variables.ADO_TOKEN,
                organization=get_workspace.set_variables.ORGANIZATION_NAME,
                project=get_workspace.set_variables.TEAM_PROJECT,
                get_inputs_from=create_workloads_adoption_request.task_id,
                epic_id=work_item_id,
                check_state=True,
                target="get_work_item_by_id"
            )


            # This variable is for checking request's state out for redirecting the right tasks after last task if it is denied or approved. 
            request_var_name = "WORKLOADS_ADOPTION_REQUEST_{}".format(work_item_id)
            request_state = Variable.get(request_var_name, default_var='is_approved')


            # REQUEST DENIED:
            # TODO: Create task that handles if Workloads Adoption Process Teams Meeting Request is denied, which closes the parent Epic work item
            # TODO: Create task that sends Teams message to requestor and owners. This DAG is done. Then it watches ADO for the next work item request.
            if request_state is not None and request_state.lower() == 'is_denied':

                send_workloads_adoption_request_denied_teams_notification_to_owners = MSTeamsWebhookOperator(
                    task_id='send_workloads_adoption_request_denied_teams_notification_to_owners',
                    webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    previous_task_id=create_workloads_adoption_request.task_id,
                    theme_color="0076D7",
                    summary='Workloads Adoption: Request Has Been Denied',
                    message='Workloads Adoption: Request Has Been Denied',
                    subtitle='Workloads Adoption Process will be deleted next',
                    image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                    button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
                )
                                    
                mark_workloads_adoption_work_item_closed = AzureDevOpsOperator(
                    task_id='mark_workloads_adoption_work_item_closed',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME, 
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    target='update_work_item',
                    get_inputs_from=mark_epic_work_item_active.task_id,
                    check_state=True,
                    state='Closed'
                )

                send_workloads_adoption_notification_to_owners = MSTeamsWebhookOperator(
                    task_id='send_workloads_adoption_notification_to_owners',
                    webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    previous_task_id=mark_epic_work_item_active.task_id,
                    theme_color="0076D7",
                    summary='Workloads Adoption Process has been deleted',
                    message='Workloads Adoption Process has been deleted',
                    subtitle='DONE',
                    image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                    button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
                )


                # [STEP 1] Dependencies: if Request Denied
                mark_epic_work_item_active >> create_workloads_adoption_request >> send_workloads_adoption_request_teams_notification_to_owners >> check_and_close_if_work_item_is_approved_or_denied >> send_workloads_adoption_request_denied_teams_notification_to_owners >> mark_workloads_adoption_work_item_closed >> send_workloads_adoption_notification_to_owners


            # REQUEST APPROVED:
            # TODO: Request is approved, send Teams message to requestor and owners
            # Send Teams notifications to Requestor Teams Channel referencing this work item
            # TODO: Create Teams channel for the requestor - TBD
            elif request_state is not None and request_state.lower() == 'is_approved':
                send_workloads_adoption_request_approval_teams_notification_to_owners = MSTeamsWebhookOperator(
                    task_id='send_workloads_adoption_request_approval_teams_notification_to_owners',
                    webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    previous_task_id=create_workloads_adoption_request.task_id,
                    theme_color="0076D7",
                    summary='Workloads Adoption: Request Has Been Approved',
                    message='Workloads Adoption: Request Has Been Approved',
                    subtitle='An Architectural Review ADO work item will be created next',
                    image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                    button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
                )
                # [STEP 1] Dependencies: if Request Approved
                mark_epic_work_item_active >> create_workloads_adoption_request >>  send_workloads_adoption_request_teams_notification_to_owners >> check_and_close_if_work_item_is_approved_or_denied >> send_workloads_adoption_request_approval_teams_notification_to_owners
                

            #####################################
            # [STEP 2]  Architectural Review    #
            #####################################

                # PARENT -> Create an ADO PARENT FEATURE work item that is a parent to child work items for: Network, ServiceNow, Compute & Data teams, which includes an expected delivery date.            
                create_architectural_review_with_cep_work_item = AzureDevOpsOperator(
                    task_id="create_architectural_review_with_cep_work_item",
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    target="create_work_item",
                    get_inputs_from=mark_epic_work_item_active.task_id,
                    work_item_type="Feature",
                    tags=onboarding_type,
                    title="[Epic {}]: Architectural Review with CEP".format(work_item_id)
                )

                # # Send Teams notifications to CEP Teams Channel referencing this work item
                send_architectural_review_with_cep_teams_notification_to_owners = MSTeamsWebhookOperator(
                    task_id='send_architectural_review_with_cep_teams_notification_to_owners',
                    webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    previous_task_id=create_architectural_review_with_cep_work_item.task_id,
                    theme_color="0076D7",
                    summary='Architectural Review with CEP work item has been created',
                    message='Architectural Review with CEP work item has been created',
                    subtitle='Once this ticket is closed, a Network Requirements work item will be created next',
                    image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                    button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
                )

                send_workloads_adoption_request_approval_teams_notification_to_owners >> create_architectural_review_with_cep_work_item >> send_architectural_review_with_cep_teams_notification_to_owners

                # # CHILD TASK -> NETWORK TEAM: Capture network spoke sizing, CIDR requests go through an approval process with ServiceNow; determine firewall rules
                create_network_requirements_work_item = AzureDevOpsOperator(
                    task_id="create_network_requirements_work_item",
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    target="create_work_item",
                    get_inputs_from=create_architectural_review_with_cep_work_item.task_id,
                    work_item_type="Task",
                    tags=onboarding_type,
                    title="[Epic {}]: Network Requirements".format(work_item_id)
                )

                # # Send Teams notifications to NETWORK Teams Channel referencing this work item
                send_network_requirements_notification_to_owners = MSTeamsWebhookOperator(
                    task_id='send_network_requirements_notification_to_owners',
                    webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    previous_task_id=create_network_requirements_work_item.task_id,
                    theme_color="0076D7",
                    summary='A Network Requirements work item has been created',
                    message='A Network Requirements work item has been created',
                    subtitle='Once this ticket is closed, a TFE Workspace Requirements work item will be created next',
                    image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                    button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
                )

                check_network_requirements_work_item_if_closed = AzureDevOpsOperator(
                    task_id='check_network_requirements_work_item_if_closed',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    get_inputs_from=create_network_requirements_work_item.task_id,
                    check_state=True,
                    target="get_work_item_by_id"
                )

                send_architectural_review_with_cep_teams_notification_to_owners >> create_network_requirements_work_item >>  send_network_requirements_notification_to_owners >> check_network_requirements_work_item_if_closed

                # # CHILD TASK -> ORCHESTRATION TEAM: Captures TFE workspace requirements; depends on previous task -> create_network_requirements_work_item
                create_tfe_workspace_requirements_work_item = AzureDevOpsOperator(
                    task_id="create_tfe_workspace_requirements_work_item",
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    target="create_work_item",
                    get_inputs_from=create_architectural_review_with_cep_work_item.task_id,
                    work_item_type="Task",
                    tags=onboarding_type,
                    title="[Epic {}]: TFE Workspace Requirements".format(work_item_id)
                )

                # # Send Teams notifications to ORCHESTRATION Teams Channel referencing this work item
                send_tfe_workspace_requirements_notification_to_owners = MSTeamsWebhookOperator(
                    task_id='send_tfe_workspace_requirements_notification_to_owners',
                    webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    previous_task_id=create_tfe_workspace_requirements_work_item.task_id,
                    theme_color="0076D7",
                    summary='A TFE Workspace Requirements work item has been created',
                    message='A TFE Workspace Requirements work item has been created',
                    subtitle='Once this ticket is closed, an Azure Requirements Compute Integration Services work item will be created next',
                    image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                    button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
                )

                check_tfe_workspace_requirements_work_item_if_closed = AzureDevOpsOperator(
                    task_id='check_tfe_workspace_requirements_work_item_if_closed',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    get_inputs_from=create_tfe_workspace_requirements_work_item.task_id,
                    check_state=True,
                    target="get_work_item_by_id"
                )   
                
                check_network_requirements_work_item_if_closed >> create_tfe_workspace_requirements_work_item >> send_tfe_workspace_requirements_notification_to_owners >> check_tfe_workspace_requirements_work_item_if_closed

                # # CHILD TASK -> AZURE SERVICE REQUIREMENTS: COMPUTE TEAM - include expected delivery date.
                create_azure_requirements_compute_integration_services_work_item = AzureDevOpsOperator(
                    task_id="create_azure_requirements_compute_integration_services_work_item",
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    target="create_work_item",
                    get_inputs_from=create_architectural_review_with_cep_work_item.task_id,
                    work_item_type="Task",
                    tags=onboarding_type,
                    title="[Epic {}]: Azure Requirements Compute Integration Services".format(work_item_id)
                )

                # # Send Teams notifications to COMPUTE Teams Channel referencing this work item
                send_azure_requirements_compute_integration_services_notification_to_owners = MSTeamsWebhookOperator(
                    task_id='send_azure_requirements_compute_integration_services_notification_to_owners',
                    webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    previous_task_id=create_azure_requirements_compute_integration_services_work_item.task_id,
                    theme_color="0076D7",
                    summary='An Azure Requirements Compute Integration Services work item has been created',
                    message='An Azure Requirements Compute Integration Services work item has been created',
                    subtitle='Once this ticket is closed, an Azure Requirements Data Services work item will be created next',
                    image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                    button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
                )

                check_azure_requirements_compute_integration_services_work_item_if_closed = AzureDevOpsOperator(
                    task_id='check_azure_requirements_compute_integration_services_work_item_if_closed',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    get_inputs_from=create_azure_requirements_compute_integration_services_work_item.task_id,
                    check_state=True,
                    target="get_work_item_by_id"
                )    

                check_tfe_workspace_requirements_work_item_if_closed >> create_azure_requirements_compute_integration_services_work_item >> send_azure_requirements_compute_integration_services_notification_to_owners >> check_azure_requirements_compute_integration_services_work_item_if_closed

                # # CHILD TASK -> AZURE SERVICE REQUIREMENTS: DATA TEAM - include expected delivery date.
                create_azure_requirements_data_services_work_item = AzureDevOpsOperator(
                    task_id="create_azure_requirements_data_services_work_item",
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    target="create_work_item",
                    get_inputs_from=create_architectural_review_with_cep_work_item.task_id,
                    work_item_type="Task",
                    tags=onboarding_type,
                    title="[Epic {}]: Azure Requirements Data Services".format(work_item_id)
                )

                # # Send Teams notifications to DATA Teams Channel referencing this work item
                send_azure_requirements_data_services_notification_to_owners = MSTeamsWebhookOperator(
                    task_id='send_azure_requirements_data_services_notification_to_owners',
                    webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    previous_task_id=create_azure_requirements_data_services_work_item.task_id,
                    theme_color="0076D7",
                    summary='An Azure Requirements Data Services work item has been created',
                    message='An Azure Requirements Data Services work item has been created',
                    subtitle='Once this ticket is closed, an Azure Requirements Network Services work item will be created next',
                    image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                    button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
                )

                check_azure_requirements_data_services_work_item_if_closed = AzureDevOpsOperator(
                    task_id='check_azure_requirements_data_services_work_item_if_closed',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    get_inputs_from=create_azure_requirements_data_services_work_item.task_id,
                    check_state=True,
                    target="get_work_item_by_id"
                )     

                check_azure_requirements_compute_integration_services_work_item_if_closed >> create_azure_requirements_data_services_work_item >> send_azure_requirements_data_services_notification_to_owners >> check_azure_requirements_data_services_work_item_if_closed

                # # CHILD TASK -> AZURE SERVICE REQUIREMENTS: NETWORK TEAM - include expected delivery date.
                create_azure_requirements_network_services_work_item = AzureDevOpsOperator(
                    task_id="create_azure_requirements_network_services_work_item",
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    target="create_work_item",
                    get_inputs_from=create_architectural_review_with_cep_work_item.task_id,
                    work_item_type="Task",
                    tags=onboarding_type,
                    title="[Epic {}]: Azure Requirements Network Services".format(work_item_id)
                )

                # # Send Teams notifications to NETWORK Teams Channel referencing this work item
                send_azure_requirements_network_services_notification_to_owners = MSTeamsWebhookOperator(
                    task_id='send_azure_requirements_network_services_notification_to_owners',
                    webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    previous_task_id=create_azure_requirements_network_services_work_item.task_id,
                    theme_color="0076D7",
                    summary='An Azure Requirements Network Services work item has been created',
                    message='An Azure Requirements Network Services work item has been created',
                    subtitle='Once this ticket is closed, an Initial Meeting work item will be created next',
                    image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                    button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
                )

                check_azure_requirements_network_services_work_item_if_closed = AzureDevOpsOperator(
                    task_id='check_azure_requirements_network_services_work_item_if_closed',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    get_inputs_from=create_azure_requirements_network_services_work_item.task_id,
                    check_state=True,
                    target="get_work_item_by_id"
                )

                check_azure_requirements_data_services_work_item_if_closed >> create_azure_requirements_network_services_work_item >> send_azure_requirements_network_services_notification_to_owners >> check_azure_requirements_network_services_work_item_if_closed

                # # CHILD TASK -> Create ADO ticket to track initial meetings and to track follow up meetings; close when review process is complete
                create_initial_meeting_work_item = AzureDevOpsOperator(
                    task_id="create_initial_meeting_work_item",
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    target="create_work_item",
                    get_inputs_from=create_architectural_review_with_cep_work_item.task_id,
                    work_item_type="Task",
                    tags=onboarding_type,
                    title="[Epic {}]: Inital Meeting to Track Follow Up Meetings".format(work_item_id)
                )

                # # Send Teams notifications to CEP Teams Channel referencing this work item.
                send_initial_meeting_notification_to_owners = MSTeamsWebhookOperator(
                    task_id='send_initial_meeting_notification_to_owners',
                    webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    previous_task_id=create_initial_meeting_work_item.task_id,
                    theme_color="0076D7",
                    summary='An Initial Meeting work item has been created',
                    message='An Initial Meeting work item has been created',
                    subtitle='Architectural Review with CEP has finished, will be deleted, and TFE Workspace Onboarding will be triggered next',
                    image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                    button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
                )

                check_initial_meeting_work_item_if_closed = AzureDevOpsOperator(
                    task_id='check_initial_meeting_work_item_if_closed',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    get_inputs_from=create_initial_meeting_work_item.task_id,
                    check_state=True,
                    target="get_work_item_by_id"
                )    

                check_azure_requirements_network_services_work_item_if_closed >> create_initial_meeting_work_item >> send_initial_meeting_notification_to_owners >> check_initial_meeting_work_item_if_closed

                mark_architectural_review_with_cep_work_item_closed = AzureDevOpsOperator(
                    task_id='mark_architectural_review_with_cep_work_item_closed',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME, 
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    target='update_work_item',
                    get_inputs_from=create_architectural_review_with_cep_work_item.task_id,
                    check_state=True,
                    state='Closed'
                )

                # [STEP 2] Dependencies
                check_initial_meeting_work_item_if_closed >> mark_architectural_review_with_cep_work_item_closed

            #############################################
            # [STEP 3] Terraform Enterprise Onboarding  #
            ############################################# 
                create_tfe_workspace_onboarding_work_item = AzureDevOpsOperator(
                    task_id='create_tfe_workspace_onboarding_work_item',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    target="create_work_item",
                    get_inputs_from=mark_epic_work_item_active.task_id,
                    work_item_type="Feature",
                    tags=onboarding_type,
                    title="[Epic {}]: TFE Workspace Onboarding".format(work_item_id)
                )

                send_tfe_workspace_onboarding_notification_to_owners = MSTeamsWebhookOperator(
                    task_id='send_tfe_workspace_onboarding_notification_to_owners',
                    webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    previous_task_id=create_tfe_workspace_onboarding_work_item.task_id,
                    theme_color="0076D7",
                    summary='A TFE Workspace Onboarding work item has been created',
                    message='A TFE Workspace Onboarding work item has been created',
                    subtitle='Once this ticket is closed, a Backlog work item will be created next',
                    image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                    button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
                )

                check_tfe_workspace_onboarding_work_item_if_closed = AzureDevOpsOperator(
                    task_id='check_tfe_workspace_onboarding_work_item_if_closed',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    get_inputs_from=create_tfe_workspace_onboarding_work_item.task_id,
                    check_state=True,
                    target="get_work_item_by_id"
                )

                mark_architectural_review_with_cep_work_item_closed >> create_tfe_workspace_onboarding_work_item >> send_tfe_workspace_onboarding_notification_to_owners >> check_tfe_workspace_onboarding_work_item_if_closed

            #####################################
            # [STEP 4]  Backlog                 #
            #####################################
                create_backlog_work_item = AzureDevOpsOperator(
                    task_id="create_backlog_work_item",
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    target="create_work_item",
                    get_inputs_from=mark_epic_work_item_active.task_id,
                    work_item_type="Feature",
                    tags=onboarding_type,
                    title="[Epic {}]: Backlog".format(work_item_id)
                )

                send_backlog_notification_to_owners = MSTeamsWebhookOperator(
                    task_id='send_backlog_notification_to_owners',
                    webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    previous_task_id=create_backlog_work_item.task_id,
                    theme_color="0076D7",
                    summary='A Backlog work item has been created',
                    message='A Backlog work item has been created',
                    subtitle='Once this ticket is closed, a Spoke Services Alignment and Delivery work item will be created',
                    image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                    button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
                )

                check_backlog_work_item_if_closed = AzureDevOpsOperator(
                    task_id='check_backlog_work_item_if_closed',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    get_inputs_from=create_backlog_work_item.task_id,
                    check_state=True,
                    target="get_work_item_by_id"
                )

                check_tfe_workspace_onboarding_work_item_if_closed >> create_backlog_work_item >> send_backlog_notification_to_owners >> check_backlog_work_item_if_closed

            #######################################################
            # [STEP 5]  Spoke Services Alignment & Delivery       #
            #######################################################
                create_spoke_services_alignment_and_delivery_work_item = AzureDevOpsOperator(
                    task_id='Spoke_Services_Alignment_and_Delivery',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    target="create_work_item",
                    get_inputs_from=mark_epic_work_item_active.task_id,
                    work_item_type="Feature",
                    tags=onboarding_type,
                    title="[Epic {}]: Spoke Services Alignment and Delivery".format(work_item_id)
                )

                send_spoke_services_alignment_and_delivery_notification_to_owners = MSTeamsWebhookOperator(
                    task_id='send_spoke_services_alignment_and_delivery_notification_to_owners',
                    webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    previous_task_id=create_spoke_services_alignment_and_delivery_work_item.task_id,
                    theme_color="0076D7",
                    summary='A Spoke Services Alignment and Delivery work item has been created',
                    message='A Spoke Services Alignment and Delivery work item has been created',
                    subtitle='Once this ticket is closed, a Stakeholder Feedback work item will be created',
                    image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                    button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
                )

                check_spoke_services_alignment_and_delivery_work_item_if_closed = AzureDevOpsOperator(
                    task_id='check_spoke_services_alignment_and_delivery_work_item_if_closed',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    get_inputs_from=create_spoke_services_alignment_and_delivery_work_item.task_id,
                    check_state=True,
                    target="get_work_item_by_id"
                )
                
                check_backlog_work_item_if_closed >> create_spoke_services_alignment_and_delivery_work_item >> send_spoke_services_alignment_and_delivery_notification_to_owners >> check_spoke_services_alignment_and_delivery_work_item_if_closed

            #####################################
            # [STEP 6]  Stakeholder Feedback    #
            #####################################
                create_stakeholder_feedback_work_item = AzureDevOpsOperator(
                    task_id='Stakeholder_Feedback',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    target="create_work_item",
                    get_inputs_from=mark_epic_work_item_active.task_id,
                    # work_item_type="Feature"
                    work_item_type="Bug",
                    tags=onboarding_type,
                    title="[Epic {}]: Stakeholder Feedbacks".format(work_item_id)
                )

                send_stakeholder_feedback_notification_to_owners = MSTeamsWebhookOperator(
                    task_id='send_stakeholder_feedback_notification_to_owners',
                    webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    previous_task_id=create_stakeholder_feedback_work_item.task_id,
                    theme_color="0076D7",
                    summary='A Stakeholder Feedback work item has been created',
                    message='A Stakeholder Feedback work item has been created',
                    subtitle='Once this ticket is closed, Workloads Adoption Epic work item will be deleted',
                    image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                    button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
                )

                check_stakeholder_feedback_work_item_if_closed = AzureDevOpsOperator(
                    task_id='check_stakeholder_feedback_work_item_if_closed',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    get_inputs_from=create_stakeholder_feedback_work_item.task_id,
                    check_state=True,
                    target="get_work_item_by_id"
                )

                check_spoke_services_alignment_and_delivery_work_item_if_closed >> create_stakeholder_feedback_work_item >> send_stakeholder_feedback_notification_to_owners >> check_stakeholder_feedback_work_item_if_closed

                #####################################
                # [LAST STEP]  Closing Epic Ticket  #
                #####################################

                mark_workloads_adoption_work_item_closed = AzureDevOpsOperator(
                    task_id='mark_workloads_adoption_work_item_closed',
                    token=get_workspace.set_variables.ADO_TOKEN,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME, 
                    project=get_workspace.set_variables.TEAM_PROJECT,
                    target='update_work_item',
                    get_inputs_from=mark_epic_work_item_active.task_id,
                    check_state=True,
                    state='Closed'
                )

                send_workloads_adoption_notification_to_owners = MSTeamsWebhookOperator(
                    task_id='send_workloads_adoption_notification_to_owners',
                    webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                    organization=get_workspace.set_variables.ORGANIZATION_NAME,
                    previous_task_id=mark_epic_work_item_active.task_id,
                    theme_color="0076D7",
                    summary='Workloads Adoption Process has been deleted',
                    message='Workloads Adoption Process has been deleted',
                    subtitle='DONE',
                    image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                    button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
                )

                # [STEP 6] Dependencies
                check_stakeholder_feedback_work_item_if_closed >> mark_workloads_adoption_work_item_closed >> send_workloads_adoption_notification_to_owners
            
        # else if ADO ticket tag contains 'new_feature'
        elif onboarding_type is not None and onboarding_type.lower() == "new_feature":

            # Mark caught Epic work item as Active to aviod of reprocessing same Epic work item.
            mark_epic_work_item_active = AzureDevOpsOperator(
                task_id='mark_epic_work_item_active',
                token=get_workspace.set_variables.ADO_TOKEN,
                organization=get_workspace.set_variables.ORGANIZATION_NAME,
                project=get_workspace.set_variables.TEAM_PROJECT,
                target='update_work_item',
                id=work_item_id,
                state='Active'
            )

            create_new_feature_work_item = AzureDevOpsOperator(
                task_id='create_new_feature_work_item',
                token=get_workspace.set_variables.ADO_TOKEN,
                organization=get_workspace.set_variables.ORGANIZATION_NAME,
                project=get_workspace.set_variables.TEAM_PROJECT,
                target="create_work_item",
                get_inputs_from=mark_epic_work_item_active.task_id,
                work_item_type="Feature",
                tags=onboarding_type,
                title="[Epic {}]: New Feature Process".format(work_item_id)
            )

            send_new_feature_notification_to_owners = MSTeamsWebhookOperator(
                task_id='send_new_feature_notification_to_owners',
                webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                organization=get_workspace.set_variables.ORGANIZATION_NAME,
                previous_task_id=create_new_feature_work_item.task_id,
                theme_color="0076D7",
                summary='New Feature Process has been created',
                message='New Feature Process has been created',
                subtitle='Work In Progress',
                image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
            )

            check_new_feature_work_item_if_closed = AzureDevOpsOperator(
                task_id='check_stakeholder_feedback_work_item_if_closed',
                token=get_workspace.set_variables.ADO_TOKEN,
                organization=get_workspace.set_variables.ORGANIZATION_NAME,
                project=get_workspace.set_variables.TEAM_PROJECT,
                get_inputs_from=create_new_feature_work_item.task_id,
                check_state=True,
                target="get_work_item_by_id"
            )

            mark_new_feature_work_item_closed = AzureDevOpsOperator(
                task_id='mark_new_feature_work_item_closed',
                token=get_workspace.set_variables.ADO_TOKEN,
                organization=get_workspace.set_variables.ORGANIZATION_NAME, 
                project=get_workspace.set_variables.TEAM_PROJECT,
                target='update_work_item',
                get_inputs_from=mark_epic_work_item_active.task_id,
                check_state=True,
                state='Closed'
            )

            send_closing_new_feature_notification_to_owners = MSTeamsWebhookOperator(
                task_id='send_closing_new_feature_notification_to_owners',
                webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
                organization=get_workspace.set_variables.ORGANIZATION_NAME,
                previous_task_id=mark_epic_work_item_active.task_id,
                theme_color="0076D7",
                summary='New Feature Process has been deleted',
                message='New Feature Process has been deleted',
                subtitle='DONE',
                image='https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
                button_url=get_workspace.set_variables.AIRFLOW_UI_URL,
            )

            # NEW FEATURE Dependencies
            mark_epic_work_item_active >> create_new_feature_work_item >> send_new_feature_notification_to_owners >> check_new_feature_work_item_if_closed >> mark_new_feature_work_item_closed >> send_closing_new_feature_notification_to_owners

    return dag

work_item_counter_var_name = "WORK_ITEM_COUNT"
work_item_counter = Variable.get(work_item_counter_var_name, default_var="0")
work_item_counter = int(work_item_counter)


for work_item in range(0, work_item_counter + 1):
    # TODO: This lines from 662-676 will need to be moved from this file into a separate file in the dags folder and it will be calling this dynamic_dag_creator.py file. 
    # TODO: This entire dynamic_dag_creator.py (minus lines 662-676) file will need to be moved to the libraries folder so it can be resued by other dags containing the code below and generate dyanmic dags for workloads & new features.
   
    work_item_id_var_name = "WORK_ITEM_ID_{}".format(work_item)
    work_item_id = Variable.get(work_item_id_var_name, default_var="0")
   
    onboarding_type_var_name = "ONBOARDING_TYPE_{}".format(work_item)
    onboarding_type = Variable.get(onboarding_type_var_name, default_var="default")

    if onboarding_type == "default" or work_item_id == "0" or onboarding_type is None or work_item_id is None:
        pass
    else:
        # Set to none for testing development & demo purposes
        cron_schedule = '@once'
        dag_id = "EPIC-{work_item_id}-{onboarding_type}".format(work_item_id = work_item_id, onboarding_type = onboarding_type.replace("_", "-").upper())

        dynamic_default_args = {
            'owner': 'DOU-DevOps',
            'start_date': datetime(2018, 1, 1),
            'retries': 1,
            'retry_delay': timedelta(minutes=1),
        }

        globals()[dag_id] = create_dag(
                dag_id=dag_id, 
                cron_schedule=cron_schedule, 
                default_args=dynamic_default_args,
                work_item_id=work_item_id,
                onboarding_type_var_name=onboarding_type_var_name,
                work_item_count = work_item
        )
