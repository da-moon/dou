import nomad
import time
from airflow.exceptions import AirflowException
from airflow.models import BaseOperator
from airflow.utils import apply_defaults
from airflow.models import Variable
import requests
import jira
from jira import JIRA
import json


class AdoOperator(BaseOperator):

    template_fields = ('summary', 'description')

    def __init__(self,
                project=None,
                summary=None,
                description=None,
                jira_username=None,
                jira_password=None,
                jira_server=None,
                issuetype={},
                *args,
                **kwargs):
        self.project = project
        self.summary = summary
        self.description = description
        self.issuetype = issuetype
        self.jira_username = jira_username
        self.jira_password = jira_password
        self.jira_server = jira_server
        super(JiraTicketOperator, self).__init__(*args, **kwargs)

    def get_auth(self):
        auth = jira.JIRA(basic_auth=(self.jira_username, self.jira_password), options={'server': self.jira_server, 'verify': False})
        return auth


    def execute(self, **kwargs):
        j = self.get_auth()
        print(j)
        print(j.projects())
        issue = j.create_issue(project=self.project, summary=self.summary, description=self.description,
                                  issuetype=self.issuetype)
        print("Issue created: %s" % (issue)) #Manual Steps


class TeamsOperator(BaseOperator):
    template_fields = ('username', 'text', 'channel')
    ui_color = '#FFBA40'

    @apply_defaults
    def __init__(self,
                 channel='#general',
                 username='Airflow',
                 text='No message has been set.\n'
                      'Here is a cat video instead\n'
                      'https://www.youtube.com/watch?v=J---aiyznGQ',
                 icon_url='https://raw.githubusercontent.com/apache/'
                          'airflow/master/airflow/www/static/pin_100.jpg',
                 webhook_url=None,
                 *args, **kwargs):
        self.channel = channel
        self.username = username
        self.text = text
        self.icon_url = icon_url
        self.webhook_url = webhook_url
        super(SlackOperator, self).__init__(*args, **kwargs)

    def construct_payload(self):
        payload = {
            'channel': self.channel,
            'username': self.username,
            'text': self.text,
            'icon_url': self.icon_url
        }
        return payload

    def execute(self, **kwargs):
        """
        SlackAPIOperator calls will not fail even if the call is not unsuccessful.
        It should not prevent a DAG from completing in success
        """
        response = requests.post(self.webhook_url, data=json.dumps(self.construct_payload()), headers={'Content-Type': 'application/json'})
        print('Response from slack call: %s' % response.text)
        print('Response code: %s' % response.status_code) #Notification
