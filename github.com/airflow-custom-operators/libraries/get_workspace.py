import os
from os import environ
import sys
sys.path.insert(1,'/home/airflow/')
from libraries import helpers as my_helper
from airflow.models import Variable


def set_variables():
    if os.environ['AIRFLOW_VAR_WORKSPACE'] is not None: 
        if os.environ['AIRFLOW_VAR_WORKSPACE'].lower() == "dou":
            # Local - DOU variables
            '''
            :param token_base64: It is for curl command in BashOperator.
            :param target: This parameter is optional for tokens. It adds ":" (colon) to beginning of the token before encoding the token.
            '''
            # ADO_TOKEN = Variable.get('DOU_ADO_ACCESS_TOKEN')
            set_variables.ADO_TOKEN = os.environ['DOU_ADO_ACCESS_TOKEN']
            set_variables.token_base64 = my_helper.encode_base64_str(set_variables.ADO_TOKEN, target="token")
            set_variables.ORGANIZATION_NAME = "leonardcastaneda"
            set_variables.TEAM_PROJECT = "DOU-Assurant-Sandbox"
            set_variables.WORK_ITEM_TYPE = "Task"
            set_variables.WORK_ITEM_ID = "2"
            set_variables.WORK_ITEM_TITLE = 'Sample task from Airflow DAG task'
            set_variables.WORK_ITEM_TAGS = ["assurant", "ado", "airflow", "dou"]
            set_variables.BACKLOG_TEAM_NAME = "Assurant-Airflow Team"
            set_variables.TEAMS_WEBHOOK_URL = os.environ['DOU_TEAMS_WEBHOOK_URL']
            set_variables.AIRFLOW_UI_URL = "http://localhost:8080"
        elif os.environ['AIRFLOW_VAR_WORKSPACE'].lower() == "assurant":
            # Assurant variables
            '''
            encode_base64_str() is a function for encoding Base64 strings. (If you encode a token, then you need to assign "target" parameter to "token".)
            token_base64: It is for curl command in BashOperator. It encodes Base64 your token which is in string format.
            target: This parameter is optional for tokens. It adds ":" (colon) to beginning of the token before encoding the token.
            '''
            set_variables.WORK_ITEM_TITLE = 'Sample task from Airflow DAG task'
            set_variables.WORK_ITEM_TAGS = ["assurant", "ado", "airflow", "dou"]
            set_variables.ADO_TOKEN = Variable.get('ASSURANT_ADO_ACCESS_TOKEN')
            set_variables.token_base64 = my_helper.encode_base64_str(set_variables.ADO_TOKEN, target="token")
            set_variables.ORGANIZATION_NAME = "AIZ-GT"
            set_variables.TEAM_PROJECT = "GT.ICS-Cloud Planning"
            set_variables.WORK_ITEM_TYPE = "Task"
            set_variables.WORK_ITEM_ID = "310933"
            set_variables.WORK_ITEM_TITLE = 'Sample task from Airflow DAG task'
            set_variables.WORK_ITEM_TAGS = "airflow"
            set_variables.BACKLOG_TEAM_NAME = "GT.ICS-Cloud Planning Team"
            set_variables.TEAMS_WEBHOOK_URL = Variable.get("ASSURANT_TEAMS_WEBHOOK_URL")
            set_variables.AIRFLOW_UI_URL = "http://10.237.161.26/admin/"
        else:
            script = os.path.realpath(__file__)
            response = "Looks like we don't have any variable in {envVar} workspace. You should check preconfigured variables in {scriptPath}".format(envVar=os.getenv('AIRFLOW_VAR_WORKSPACE'), scriptPath=script)
            raise AirflowException(response)
    else:
        # print("You need to assign an env variable which is named 'AIRFLOW_VAR_WORKSPACE'")
        raise AirflowException("You need to assign an env variable which is named 'AIRFLOW_VAR_WORKSPACE'")
