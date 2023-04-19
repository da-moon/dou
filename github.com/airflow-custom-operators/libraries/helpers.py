import base64
import string
import os
from libraries import get_workspace
from libraries.teams_operator import MSTeamsWebhookOperator


# This convert_list_to_str function is for converting lists to the string format.
def convert_list_to_str(join_my_list):
    if type(join_my_list) is list:
        if len(join_my_list) < 2:
            return '%s' % (str(join_my_list[-1]))
        else:
            return '%s, %s' % (', '.join(join_my_list[:-1]), str(join_my_list[-1]))

def convert_list_to_str_with_and(join_my_list):
    if type(join_my_list) is list:
        if len(join_my_list) < 2:
            return '%s' % (str(join_my_list[-1]))
        else:
            return '%s AND %s' % (' AND '.join(join_my_list[:-1]), str(join_my_list[-1]))

def convert_list_to_str_with_or(join_my_list):
    if type(join_my_list) is list:
        if len(join_my_list) < 2:
            return '%s' % (str(join_my_list[-1]))
        else:
            return '%s OR %s' % (' OR '.join(join_my_list[:-1]), str(join_my_list[-1]))

def convert_list_to_str_with_semicolon(join_my_list):
    if type(join_my_list) is list:
        if len(join_my_list) < 2:
            return '%s' % (str(join_my_list[-1]))
        else:
            return '%s; %s' % ('; '.join(join_my_list[:-1]), str(join_my_list[-1]))

# This encode_base64_str function is for encoding strings in Base64 format.
def encode_base64_str(my_var, **kwargs):
    target = kwargs.get('target', None)
    if target is not None and target.lower() == "token":
        my_var = ":" + my_var
    my_var_bytes = my_var.encode("ascii")
    base64_bytes = base64.b64encode(my_var_bytes)
    base64_string = base64_bytes.decode("ascii")
    return base64_string

def create_a_query(select_query=None, from_query=None, where_query=None, where_type=None, order_by_query=None, type_of_order=None):
    full_query = ""
    # SELECT
    if type(select_query) is list:
        full_query = "SELECT {select_item}".format(select_item=convert_list_to_str(select_query))
    elif type(select_query) is str:
        full_query = "SELECT {select_item}".format(select_item=select_query)
    # FROM
    if type(from_query) is list:
        full_query = full_query + " FROM {from_item}".format(from_item=convert_list_to_str(from_query))
    elif type(from_query) is str:
        full_query = full_query + " FROM {from_item}".format(from_item=from_query)
    # WHERE
    if type(where_type) is list:
        where_type = convert_list_to_str(where_type)
    if type(where_query) is list and where_type is not None and where_type.upper() == "AND":
        full_query = full_query + " WHERE {where_item}".format(where_item=convert_list_to_str_with_and(where_query))
    elif type(where_query) is list and where_type is not None and where_type.upper() == "OR":
        full_query = full_query + " WHERE {where_item}".format(where_item=convert_list_to_str_with_or(where_query))
    elif type(where_query) is list and where_type is None:
        full_query = full_query + " WHERE {where_item}".format(where_item=convert_list_to_str(where_query))
    elif type(where_query) is str:
        full_query = full_query + " WHERE {where_item}".format(where_item=where_query)
    # ORDER BY
    if type(order_by_query) is list:
        full_query = full_query + " ORDER BY {order_by_item}".format(order_by_item=convert_list_to_str(order_by_query))
        if type(type_of_order) is list:
            full_query = full_query + " {type_order}".format(type_order=convert_list_to_str(type_of_order))
        elif type(type_of_order) is str:
            full_query = full_query + " {type_order}".format(type_order=type_of_order)
    elif type(order_by_query) is str:
        full_query = full_query + " ORDER BY {order_by_item}".format(order_by_item=order_by_query)
        if type(type_of_order) is list:
            full_query = full_query + " {type_order}".format(type_order=convert_list_to_str(type_of_order))
        elif type(type_of_order) is str:
            full_query = full_query + " {type_order}".format(type_order=type_of_order)
    return full_query

def add_body(item, target):
    target = string.capwords(target).replace(" ", "")
    if target.lower == "assignedto":
        target = "AssignedTo"
    elif target.lower == "areapath":
        target = "AreaPath"
    elif target.lower == "iterationpath":
        target = "IterationPath"
    if item is not None and target is not None:
        if type(item) is list:
            item = convert_list_to_str_with_semicolon(item)
        my_title = '"op": "add","path": "/fields/System.{}","from": null,"value": "{}"'.format(target,item)
        my_title = '{' + my_title + '}'
        return my_title
        
def on_failure(context):
    # if os.environ['AIRFLOW_VAR_WORKSPACE'].lower() == "dou":
    #     AIRFLOW_UI_URL = "http://localhost:8080"
    # elif os.environ['AIRFLOW_VAR_WORKSPACE'].lower() == "assurant":
    #     AIRFLOW_UI_URL = "http://10.237.161.26/admin/"
    get_workspace.set_variables()
    dag_id = context['dag_run'].dag_id

    previous_task_id = context['task_instance'].task_id
    context['task_instance'].xcom_push(key=dag_id, value=True)

    logs_url = "{}/admin/airflow/log?dag_id={}&task_id={}&execution_date={}".format(
         get_workspace.set_variables.AIRFLOW_UI_URL, dag_id, previous_task_id, context['ts'])

    teams_notification = MSTeamsWebhookOperator(
        task_id="msteams_notify_failure", trigger_rule="all_done",
        message="`{}` has failed on task: `{}`".format(dag_id, previous_task_id),
        previous_task_id=previous_task_id,
        summary='Airflow Teams Operator',
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        button_text="View log", button_url=logs_url,
        subtitle = "Click on the button to see the log.",
        image = 'https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        theme_color="FF0000")
    teams_notification.execute(context)

def on_success(context):
    # if os.environ['AIRFLOW_VAR_WORKSPACE'].lower() == "dou":
    #     AIRFLOW_UI_URL = "http://localhost:8080"
    # elif os.environ['AIRFLOW_VAR_WORKSPACE'].lower() == "assurant":
    #     AIRFLOW_UI_URL = "http://10.237.161.26/admin/"
    get_workspace.set_variables()
    dag_id = context['dag_run'].dag_id

    task_id = context['task_instance'].task_id
    context['task_instance'].xcom_push(key=dag_id, value=True)

    logs_url = "{}/admin/airflow/log?dag_id={}&task_id={}&execution_date={}".format(
         get_workspace.set_variables.AIRFLOW_UI_URL, dag_id, task_id, context['ts'])

    teams_notification = MSTeamsWebhookOperator(
        task_id="msteams_notify_success", trigger_rule="all_done",
        message="`{}` has succeeded on task: `{}`".format(dag_id, task_id),
        webhook_url=get_workspace.set_variables.TEAMS_WEBHOOK_URL,
        summary='Airflow Teams Operator',
        subtitle = "Click on the button to see the log.",
        button_text="View log", button_url=logs_url,
        image = 'https://camo.githubusercontent.com/d457cb4a66ef99afcdb5893496700d79864d07e92c7ac95a0ff10f9744eb39ae/68747470733a2f2f616972626e622e696f2f696d672f70726f6a656374732f616972666c6f77332e706e67',
        theme_color="FF0000")
    teams_notification.execute(context)