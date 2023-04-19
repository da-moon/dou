from airflow.models import BaseOperator
from airflow.utils import apply_defaults
from datetime import datetime
import requests
import logging


class MSTeamsWebhookOperator(BaseOperator):
    """
    This operator allows you to post messages to MS Teams using the Incoming Webhooks connector.
    Takes both MS Teams webhook token directly and connection that has MS Teams webhook token.
    If both supplied, the webhook token will be appended to the host in the connection.
    :param http_conn_id: connection that has MS Teams webhook URL
    :type http_conn_id: str
    :param webhook_url: MS Teams webhook token
    :type webhook_url: str
    :param message: The message you want to send on MS Teams
    :type message: str
    :param subtitle: The subtitle of the message to send
    :type subtitle: str
    :param button_text: The text of the action button
    :type button_text: str
    :param button_url: The URL for the action button click
    :type button_url : str
    :param theme_color: Hex code of the card theme, without the #
    :type message: str
    :param proxy: Proxy to use when making the webhook request
    :type proxy: str
    """

    template_fields = ('message', 'subtitle',)

    @apply_defaults
    def __init__(self,
                 webhook_url=None,
                 theme_color="00FF00",
                 summary="",
                 message="",
                 subtitle="",
                 previous_task_id="",
                 image="",
                 button_text="",
                 button_url="",
                 proxy=None,
                 organization=None,
                 *args,
                 **kwargs):

        super(MSTeamsWebhookOperator, self).__init__(endpoint=webhook_url, *args, **kwargs)
        self.webhook_url = webhook_url
        self.theme_color = theme_color
        self.summary = summary
        self.message = message
        self.subtitle = subtitle
        self.previous_task_id = previous_task_id
        self.image = image
        self.button_text = button_text
        self.button_url = button_url
        self.organization = organization

    
    def default_build_message(self, exec_time, run_id):
        now = datetime.now()
        dt_string = now.strftime("%Y-%m-%dT%H:%M:%S")

        cardjson = """
            {{
                "@type": "MessageCard",
                "@context": "http://schema.org/extensions",
                "themeColor": "{theme_color}",
                "summary": "{summary}",
                "sections": [{{
                    "activityTitle": "{title}",
                    "activitySubtitle": "{subtitle}",
                    "activityImage": "{image}",
                    "facts": [{{
                            "name": "{run_id}-STARTED",
                            "value": "{exec_time}"
                        }}, {{
                            "name": "{run_id}-ENDED",
                            "value": "{dt_string}"
                        }}
                    "markdown": true,
                    "potentialAction": [
                        {{
                            "@type": "OpenUri",
                            "name": "{button_text}",
                            "targets": [
                                {{ "os": "default", "uri": "{button_url}" }}
                            ]
                        }}
                    ]
                }}]
            }}
        """
        return cardjson.format(
            theme_color = self.theme_color,
            summary = self.summary, 
            title = self.message, 
            subtitle = self.subtitle,
            image = self.image, 
            button_text = self.button_text, 
            button_url = self.button_url,
            run_id = run_id, 
            exec_time = exec_time, 
            dt_string = dt_string)

    def ado_build_message(self, exec_time, run_id,  vars_from_ado, logs_url):

        now = datetime.now()
        dt_string = now.strftime("%Y-%m-%dT%H:%M:%S")

        # If State is needed, you can add this part into facts in cardjson variable below.
                        #     "name": "Status",
                        #     "value": "{state}"
                        # }}, {{


        cardjson = """
            {{
                "@type": "MessageCard",
                "@context": "http://schema.org/extensions",
                "themeColor": "{theme_color}",
                "summary": "{summary}",
                "sections": [{{
                    "activityTitle": "{title}",
                    "activitySubtitle": "{subtitle}",
                    "activityImage": "{image}",
                    "facts": [{{
                            "name": "Organization",
                            "value": "{organization}"
                        }}, {{
                            "name": "Team Project",
                            "value": "{project}"
                        }}, {{
                            "name": "Work Item Id",
                            "value": "{work_item_id}"
                        }}, {{
                            "name": "Title",
                            "value": "{work_item_title}"
                        }}, {{
                            "name": "Assigned to",
                            "value": "{assigned_to}"
                        }}, {{
                            "name": "Tags",
                            "value": "{tags}"
                        }}, {{
                            "name": "STARTED-{run_id}",
                            "value": "{exec_time}"
                        }}, {{
                            "name": "ENDED-{run_id}",
                            "value": "{dt_string}"
                        }}],
                    "markdown": true,
                    "potentialAction": [
                        {{
                            "@type": "OpenUri",
                            "name": "View DAG",
                            "targets": [
                                {{ "os": "default", "uri": "{button_url}" }}
                            ]
                        }}, {{
                            "@type": "OpenUri",
                            "name": "View Work Item",
                            "targets": [
                                {{ "os": "default", "uri": "https://dev.azure.com/{organization}/{project}/_workitems/edit/{work_item_id}" }}
                            ]
                        }}
                    ]              
                }}]
            }}
        """
        return cardjson.format(
            theme_color = self.theme_color, 
            summary = self.summary, 
            title = self.message, 
            subtitle = self.subtitle,
            image = self.image, 
            organization = vars_from_ado['organization'].replace(" ", "%20"),
            project = vars_from_ado['project'].replace(" ", "%20"),
            work_item_title = vars_from_ado['title'],
            work_item_id = vars_from_ado['work_item_id'],
            assigned_to = vars_from_ado['assigned_to'],
            # state = vars_from_ado['state'],
            tags = vars_from_ado['tags'],
            run_id = run_id, 
            exec_time = exec_time, 
            dt_string = dt_string,
            button_text = self.button_text,
            button_url = logs_url
        )

    def execute(self, context):
        """
        Post to Teams channel
        """
        my_run_id = context['dag_run'].dag_id
        execution_date = context.get("execution_date")
        if self.organization is None:
            response = requests.post(
                self.webhook_url, 
                data=self.default_build_message(exec_time=execution_date, run_id=my_run_id),
                headers={'Content-Type': 'application/json'})
        else:
            dag_id = context['dag_run'].dag_id
            logs_url = "{}/admin/airflow/graph?dag_id={}&execution_date={}".format(
                self.button_url, dag_id, context['ts'])
            inputs = context["task_instance"].xcom_pull(task_ids=self.previous_task_id)
            vars_from_ado = {
                'work_item_id' : 'Empty',
                'title' : 'Empty',
                'tags' : 'Empty',
                'assigned_to' : 'Empty',
                # 'state' : 'Empty',
                'project' : 'Empty',
                'organization' : 'Empty'
                }
            vars_from_ado['organization'] = self.organization
            vars_from_ado['work_item_id'] = inputs[0]
            if "System.Title" in inputs[1].fields.keys():
                vars_from_ado['title'] = inputs[1].fields['System.Title']
            if "System.Tags" in inputs[1].fields.keys():
                vars_from_ado['tags'] = inputs[1].fields['System.Tags']
            if "System.AssignedTo" in inputs[1].fields.keys() and "displayName" in inputs[1].fields["System.AssignedTo"].keys():
                vars_from_ado['assigned_to'] = inputs[1].fields['System.AssignedTo']['displayName']
            # if "System.State" in inputs[1].fields.keys():
            #     vars_from_ado['state'] = inputs[1].fields['System.State']
            if "System.TeamProject" in inputs[1].fields.keys():
                vars_from_ado['project'] = inputs[1].fields['System.TeamProject']
            response = requests.post(
                self.webhook_url, 
                data=self.ado_build_message(exec_time=execution_date, run_id=my_run_id, vars_from_ado=vars_from_ado, logs_url=logs_url),
                headers={'Content-Type': 'application/json'})

        print('Response from teams call: %s' % response.text)
        print('Response code: %s' % response.status_code) #Notification

        if response.status_code == '200':
            logging.info("Webhook request sent to MS Teams")
