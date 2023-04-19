from os import environ, link
from airflow.exceptions import AirflowException
from airflow.models import BaseOperator, Variable
from airflow.utils import apply_defaults
from msrest.authentication import BasicAuthentication
from azure.devops.connection import Connection
from azure.devops.v5_1.work_item_tracking.models import JsonPatchOperation, Link, Wiql
import sys
sys.path.insert(1,'/home/airflow/')
from libraries import helpers as my_helper
import json


class AzureDevOpsOperator(BaseOperator):

    template_fields = ('title', 'id', 'state')

    @apply_defaults
    def __init__(self,
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
                destroy=False,
                get_inputs_from=None,
                second_get_inputs_from=None,
                result=None,
                check_state=False,
                vdc_onboarding=False,
                owners=None,
                by_tag=False,
                step=None,
                epic_id=None,
                *args,
                **kwargs):
        self.project = project
        self.title = title
        self.id = id
        self.state = state
        self.token = token
        self.query = query
        self.target = target
        self.organization = organization
        self.work_item_type = work_item_type
        self.description = description
        self.assigned_to = assigned_to
        self.area = area
        self.iteration = iteration
        self.reason = reason
        self.discussion = discussion
        self.fields = fields
        self.tags = tags
        self.destroy = destroy
        self.get_inputs_from = get_inputs_from
        self.second_get_inputs_from = second_get_inputs_from
        self.result = result
        self.check_state = check_state
        self.vdc_onboarding = vdc_onboarding
        self.owners = owners
        self.by_tag = by_tag
        self.step = step
        self.epic_id = epic_id
        super(AzureDevOpsOperator, self).__init__(*args, **kwargs)

    def get_auth(self):
        organization_uri = "https://dev.azure.com:443/{org_name}/".format(org_name = self.organization)
        #This crendentials variable encrypts your authentication to Base64 format.
        credentials = BasicAuthentication("", self.token)
        connection = Connection(base_url=organization_uri, creds=credentials)
        return connection

    def get_all_work_items_from_query(self, query, wit_client):
        '''
            This get_all_work_items_from_query function runs our query, gets the result, 
            and sends it to the function which is called get_work_items_metadata for filtering the result.
        '''
        query_wiql = Wiql(query=query)
        results = wit_client.query_by_wiql(query_wiql).work_items
        # WIQL query gives a WorkItemReference => we get the corresponding WorkItem from id
        work_items = (wit_client.get_work_item(int(result.id), expand="All") for result in results)
        self.get_work_items_metadata(work_items=work_items)

    def get_work_items_metadata(self, work_items, **context):
        '''
            This get_work_items_metadata function gets work items data from the get_all_work_items_from_query result.
        '''
        self.result = "\n"
        if self.target.lower() == 'query_by_tag':
            for work_item in work_items:
                check_var_exist = False
                work_item_counter = Variable.get("WORK_ITEM_COUNT", default_var="0")
                work_item_counter = int(work_item_counter)
                for counter in range(0, work_item_counter + 1):
                    previous_work_item_name = "WORK_ITEM_ID_{}".format(counter)
                    previous_work_item = Variable.get(previous_work_item_name, default_var="0")
                    if int(previous_work_item) == int(work_item.id):
                        print("This work item {} already exist.".format(work_item.id))
                        check_var_exist = True
                if check_var_exist is False:
                    work_item_counter = work_item_counter + 1
                    Variable.set("WORK_ITEM_COUNT", work_item_counter)
                    self.result = []
                    self.result.append(work_item.id)
                    self.result.append(work_item)
                    onboarding_type_var_name = "ONBOARDING_TYPE_{}".format(work_item_counter)
                    Variable.set(onboarding_type_var_name, self.result[1].fields["System.Tags"])
                    work_item_id_var_name = "WORK_ITEM_ID_{}".format(work_item_counter)
                    Variable.set(work_item_id_var_name, self.result[0])
            if self.result == "\n":
                self.result = None
        else:
            for work_item in work_items:
                self.result = self.result + "{0} {1}: {2}\n\tState: {3}\n".format(
                        work_item.fields["System.WorkItemType"],
                        work_item.id,
                        work_item.fields["System.Title"],
                        work_item.fields["System.State"]
                    )
                if "System.Tags" in work_item.fields.keys():
                    self.result = self.result + "\tTags: {tag}\n".format(
                        tag=work_item.fields["System.Tags"]
                    )
                if "System.AssignedTo" in work_item.fields.keys() and "displayName" in work_item.fields["System.AssignedTo"].keys():
                    self.result = self.result + "\tAssigned to: {assigned}\n".format(
                        assigned=work_item.fields["System.AssignedTo"]["displayName"]
                    )
            print(self.result)

    def get_all_work_items_by_tag(self, wit_client, tag):
        '''
            This get_all_work_items_by_tag function runs our query, gets the result, 
            and sends it to the function which is called get_work_items_metadata for filtering the result.
        '''
        SELECT_ITEMS = ['[System.Title]', '[System.State]', '[System.AreaPath]', '[System.IterationPath]']
        FROM_ITEMS = "WorkItems"
        WHERE_ITEMS = "[System.TeamProject]='{teamProject}' AND [System.WorkItemType]='{workItemType}' AND [System.State]='New' AND [System.Tags] CONTAINS '{tags}'".format(teamProject = self.project, workItemType = self.work_item_type, tags= tag)
        ORDER_BY_ITEMS = "[System.Id]"
        ORDER_TYPE = "DESC"
        self.query = my_helper.create_a_query(select_query=SELECT_ITEMS, from_query=FROM_ITEMS, where_query=WHERE_ITEMS, order_by_query=ORDER_BY_ITEMS, type_of_order=ORDER_TYPE)

        query_wiql = Wiql(query=self.query)
        results = wit_client.query_by_wiql(query_wiql).work_items
        # WIQL query gives a WorkItemReference => we get the corresponding WorkItem from id
        work_items = (wit_client.get_work_item(int(result.id), expand="All") for result in results)
        self.get_work_items_metadata(work_items=work_items)

    def get_work_item_by_id(self, client, id):
        work_item = client.get_work_item(int(id), expand='All')
        if self.check_state is False:
            result = "\n"
            result = result + "{0} {1}: {2}\n\tState: {3}\n".format(
                    work_item.fields["System.WorkItemType"],
                    work_item.id,
                    work_item.fields["System.Title"],
                    work_item.fields["System.State"]
                )
            if "System.Tags" in work_item.fields.keys():
                result = result + "\tTags: {tag}\n".format(
                    tag=work_item.fields["System.Tags"]
                )
            if "System.AssignedTo" in work_item.fields.keys() and "displayName" in work_item.fields["System.AssignedTo"].keys():
                result = result + "\tAssigned to: {assigned}\n".format(
                    assigned=work_item.fields["System.AssignedTo"]["displayName"]
                )
            print(result)
        elif self.check_state is True and work_item.fields["System.State"] == "Closed":
            self.check_state = False
            if "System.Tags" in work_item.fields.keys():
                tags_list = work_item.fields["System.Tags"].split("; ")
                # tags_list = self._convert_str_with_semicolon_to_list(join_my_list=work_item.fields["System.Tags"])
                print(tags_list)
                for tag in tags_list:     #    request_denied, workloads_adoption
                    print(tag)
                    request_var_name = "WORKLOADS_ADOPTION_REQUEST_{}".format(self.epic_id)
                    if tag == "request_denied":
                        Variable.set(request_var_name, 'is_denied')
                        break
                        # raise ValueError("Workloads Adoption request denied, closing {0} ticket.".format(id))
                    else:
                        Variable.set(request_var_name, 'is_approved')

    def create_work_item(self, client, parent_task_id=None):
        """Create a work item.
        :param work_item_type: Name of the work item type (e.g. Bug).
        :type work_item_type: str
        :param title: Title of the work item.
        :type title: str
        :param description: Description of the work item.
        :type description: str
        :param assigned_to: Name of the person the work item is assigned-to (e.g. fabrikam).
        :type assigned_to: str
        :param area: Area the work item is assigned to (e.g. Demos)
        :type area: str
        :param iteration: Iteration path of the work item (e.g. Demos\Iteration 1).
        :type iteration: str
        :param reason: Reason for the state of the work item.
        :type reason: str
        :param discussion: Comment to add to a discussion in a work item.
        :type discussion: str
        :param fields: Space separated "field=value" pairs for custom fields you would like to set.
        :type fields: [str]
        :rtype: :class:`<WorkItem> <v5_0.work-item-tracking.models.WorkItem>`
        """
        patch_document = []
        if self.title is not None:
            patch_document.append(self._create_work_item_field_patch_operation('add', 'System.Title', self.title))
        else:
            raise ValueError('--title is a required argument.')
        if self.description is not None:
            patch_document.append(self._create_work_item_field_patch_operation('add', 'System.Description', self.description))
        if self.assigned_to is not None:
            # 'assigned to' does not take an identity id.  Display name works.
            assigned_to = self.assigned_to.strip()
            patch_document.append(self._create_work_item_field_patch_operation('add', 'System.AssignedTo', assigned_to))
        if self.area is not None:
            patch_document.append(self._create_work_item_field_patch_operation('add', 'System.AreaPath', self.area))
        if self.iteration is not None:
            patch_document.append(self._create_work_item_field_patch_operation('add', 'System.IterationPath', self.iteration))
        if self.reason is not None:
            patch_document.append(self._create_work_item_field_patch_operation('add', 'System.Reason', self.reason))
        if self.discussion is not None:
            patch_document.append(self._create_work_item_field_patch_operation('add', 'System.History', self.discussion))
        if self.tags is not None:
            if type(self.tags) is list:
                self.tags = '; '.join(str(tag) for tag in self.tags)
            patch_document.append(self._create_work_item_field_patch_operation('add', 'System.Tags', self.tags))
        if parent_task_id is not None:
            # link_document = ""
            url = "https://dev.azure.com/{organizationName}/{teamProject}/_apis/wit/workItems/{workItemId}".format(
                    organizationName = self.organization.replace(" ", "%20"),
                    teamProject = self.project.replace(" ", "%20"),
                    workItemId = parent_task_id
                    )
            attributes = { "comment" : "Parent Work Item" }
                        # "isLocked" : "IsLocked" }
            # link_document = link_document + self._create_link_patch_operation('System.LinkTypes.Hierarchy-Reverse', url, attributes)
            patch_document.append(self._create_patch_operation('add', '/relations/-', self._create_link_patch_operation(rel='System.LinkTypes.Hierarchy-Reverse', url=url, attributes=attributes)))
        if self.fields is not None and self.fields:
            for field in self.fields:
                kvp = field.split('=', 1)
                if len(kvp) == 2:
                    patch_document.append(self._create_work_item_field_patch_operation('add', kvp[0], kvp[1]))
                else:
                    raise ValueError('The --fields argument should consist of space separated "field=value" pairs.')
        work_item = client.create_work_item(document=patch_document, project=self.project, type=self.work_item_type)
        self.result = []
        self.result.append(work_item.id)
        self.result.append(work_item)

    def _create_patch_operation(self, op, path, value, *args, **kwargs):
        patch_operation = JsonPatchOperation()
        patch_operation.op = op
        patch_operation.path = path
        patch_operation.value = value
        return patch_operation

    def _create_work_item_field_patch_operation(self, op, field, value):
        path = '/fields/{field}'.format(field=field)
        return self._create_patch_operation(op=op, path=path, value=value)

    def _create_link_patch_operation(self, rel, url, attributes, *args, **kwargs):
        link_patch_operation = Link()
        link_patch_operation.rel = rel
        link_patch_operation.url = url
        link_patch_operation.attributes = attributes
        return link_patch_operation

    def _convert_str_with_semicolon_to_list(join_my_list):
        return join_my_list.split("; ")

    def update_work_item(self, client, parent_task_id=None):
        """Update work items.
        :param id: The id of the work item to update.
        :type id: int
        :param title: Title of the work item.
        :type title: str
        :param description: Description of the work item.
        :type description: str
        :param assigned_to: Name of the person the work item is assigned-to (e.g. fabrikam).
        :type assigned_to: str
        :param state: State of the work item (e.g. active).
        :type state: str
        :param area: Area the work item is assigned to (e.g. Demos).
        :type area: str
        :param iteration: Iteration path of the work item (e.g. Demos\Iteration 1).
        :type iteration: str
        :param reason: Reason for the state of the work item.
        :type reason: str
        :param discussion: Comment to add to a discussion in a work item.
        :type discussion: str
        :param fields: Space separated "field=value" pairs for custom fields you would like to set.
        :type fields: [str]
        :param open: Open the work item in the default web browser.
        :type open: bool
        :rtype: :class:`<WorkItem> <v5_0.work-item-tracking.models.WorkItem>`
        """
        patch_document = []
        if self.title is not None:
            patch_document.append(self._create_work_item_field_patch_operation('add', 'System.Title', self.title))
        if self.description is not None:
            patch_document.append(self._create_work_item_field_patch_operation('add', 'System.Description', self.description))
        if self.assigned_to is not None:
            assigned_to = self.assigned_to.strip()
            # 'assigned to' does not take an identity id.  Display name works.
            if assigned_to == '':
                resolved_assigned_to = ''
            if resolved_assigned_to is not None:
                patch_document.append(self._create_work_item_field_patch_operation('add', 'System.AssignedTo',
                                                                            resolved_assigned_to))
        if self.state is not None:
            patch_document.append(self._create_work_item_field_patch_operation('add', 'System.State', self.state))
        if self.area is not None:
            patch_document.append(self._create_work_item_field_patch_operation('add', 'System.AreaPath', self.area))
        if self.iteration is not None:
            patch_document.append(self._create_work_item_field_patch_operation('add', 'System.IterationPath', self.iteration))
        if self.reason is not None:
            patch_document.append(self._create_work_item_field_patch_operation('add', 'System.Reason', self.reason))
        if self.discussion is not None:
            patch_document.append(self._create_work_item_field_patch_operation('add', 'System.History', self.discussion))
        if parent_task_id is not None:
            # link_document = ""
            url = "https://dev.azure.com/{organizationName}/{teamProject}/_apis/wit/workItems/{workItemId}".format(
                    organizationName = self.organization.replace(" ", "%20"),
                    teamProject = self.project.replace(" ", "%20"),
                    workItemId = parent_task_id
                    )
            attributes = { "comment" : "Parent Work Item" }
                        # "isLocked" : "IsLocked" }
            print("parent_task_id is {}".format(parent_task_id))
            # link_document = link_document + self._create_link_patch_operation('System.LinkTypes.Hierarchy-Reverse', url, attributes)
            patch_document.append(self._create_patch_operation('add', '/relations/-', self._create_link_patch_operation(rel='System.LinkTypes.Hierarchy-Reverse', url=url, attributes=attributes)))
        if self.fields is not None and self.fields:
            for field in self.fields:
                kvp = field.split('=', 1)
                if len(kvp) == 2:
                    patch_document.append(self._create_work_item_field_patch_operation('add', kvp[0], kvp[1]))
                else:
                    raise ValueError('The --fields argument should consist of space separated "field=value" pairs.')
        work_item = client.update_work_item(document=patch_document, id=self.id)
        self.result = []
        self.result.append(work_item.id)
        self.result.append(work_item)

    def delete_work_item(self, client):
        """Delete a work item.
        :param id: Unique id of the work item.
        :type id: int
        :param destroy: Permanently delete this work item.
        :type destroy: bool
        :rtype: :class:`<WorkItem> <v5_0.work-item-tracking.models.WorkItemDelete>`
        """
        delete_response = client.delete_work_item(id=self.id, project=self.project, destroy=self.destroy)
        if self.destroy is True:
            print('Destroyed work item {}'.format(id))
        else:
            print('Deleted work item {}'.format(id))
        return delete_response

    def execute(self, context):
        connection = self.get_auth() #Authentication for ADO
        client = connection.clients.get_work_item_tracking_client()
        inputs = context["task_instance"].xcom_pull(self.get_inputs_from)
        second_inputs = context["task_instance"].xcom_pull(self.second_get_inputs_from)
        if self.vdc_onboarding:
            if self.step == '2':
                self.tags = []
                if type(self.owners) is list:
                    for owner in self.owners:
                        self.tags.append(owner)
                if type(self.owners) is not list:       
                    self.tags.append(self.owners)
                app_name = context["dag_run"].conf.get('application_name')
                self.tags.append(app_name)
                self.assigned_to = context["dag_run"].conf.get('solution_architect')
                # TODO: Fix @mentions
                self.discussion = "Application Architect is @{applicationArchitect}, Technical Leader is @{technicalLeader}".format(applicationArchitect=context["dag_run"].conf.get('application_architect'), technicalLeader=context["dag_run"].conf.get('technical_leader'))
            
                # context["dag_run"].conf.get('')
                # self.tags = context["task_instance"].xcom_pull(key='application_name', task_ids='parse_job_args_task')
                # self.assigned_to = context["task_instance"].xcom_pull(key='solution_architect', task_ids='parse_job_args_task')
                # self.discussion = "Application Architect is @{applicationArchitect}, Technical Leader is @{technicalLeader}".format(applicationArchitect=context["task_instance"].xcom_pull(key='application_architect', task_ids='parse_job_args_task'), technicalLeader=context["task_instance"].xcom_pull(key='technical_leader', task_ids='parse_job_args_task'))
                # self.id = context["task_instance"].xcom_pull('application_name')
                # self.id = context["task_instance"].xcom_pull('application_name')
            elif self.step == '3':
                self.tags = []
                if type(self.owners) is list:
                    for owner in self.owners:
                        self.tags.append(owner)
                if type(self.owners) is not list:       
                    self.tags.append(self.owners)
                app_name = context["dag_run"].conf.get('application_name')
                self.tags.append(app_name)
                environment = context["dag_run"].conf.get('environment')
                self.description = self.description + '\n' + 'If ESAM, new subscription with name {app}-{env}. \nIf Non-ESAM, resources groups created in shared dev, model, and prod subscriptions'.format(app=app_name, env=environment)
                # TODO: Determine who the assigned_to, solution_architect is a placeholder for now.
                self.assigned_to = context["dag_run"].conf.get('solution_architect')
            # TODO: Need to break these steps up into separate elif use-case statements??
            elif self.step == '4' or '5' or '6' or '7' or '8' or '9' or '10' or '11' or '12' or '13' or '14' or '15' or '16' or '17' or '18' or '19':
                self.tags = []
                if type(self.owners) is list:
                    for owner in self.owners:
                        self.tags.append(owner)
                if type(self.owners) is not list:       
                    self.tags.append(self.owners)
                app_name = context["dag_run"].conf.get('application_name')
                self.tags.append(app_name)
                environment = context["dag_run"].conf.get('environment')
                self.description = self.description
                # TODO: Determine who the assigned_to, solution_architect is a placeholder for now.
                self.assigned_to = context["dag_run"].conf.get('solution_architect')
        if self.target is None:
            print("\n\n\nTarget variable must be set as one of these;\n\n\twiql, \n\tget_work_item_by_id, \n\tcreate_work_item, \n\tupdate_work_item, \n\tdelete_work_item, \n\trepo, \n\tboards, \n\tartifacts.\n\n\n.")
        else:
            if self.target.lower() == "wiql" :
                self.get_all_work_items_from_query(wit_client=client, query=self.query)
                key_name = "my_query_result_{}".format(context['task'].dag_id)
                context['task_instance'].xcom_push(key=key_name, value=self.result)
            elif self.target.lower() == "query_by_tag":
                # while self.result is None:
                if self.tags is not None:
                    for work_item_tag in self.tags:
                        self.get_all_work_items_by_tag(wit_client=client, tag=work_item_tag)
                        print(self.result)
                        if self.result is not None:
                            break
                    if self.result is None:
                        raise ValueError("There are no WorkItems containing any of these {tags} tags.".format(tags=self.tags))
                    return self.result
                else:
                    raise ValueError("You must specify at least one tag in 'tags' variable once you call this function")
            elif self.target.lower() == "get_work_item_by_id":
                if self.id is not None:
                    self.get_work_item_by_id(client=client, id=self.id)
                elif self.id is None:
                    while self.check_state is True:
                        self.get_work_item_by_id(client=client, id=inputs[0])
            elif self.target.lower() == "create_work_item" :
                if self.work_item_type is None and self.title is None and self.project is None:
                    raise ValueError("You have to specify a value for Work Item Type, Project, and Title field parameters.")
                else:
                    if self.get_inputs_from is not None:
                        if "System.AssignedTo" in inputs[1].fields.keys() and "displayName" in inputs[1].fields["System.AssignedTo"].keys():
                            self.assigned_to = inputs[1].fields["System.AssignedTo"]["displayName"]
                        self.create_work_item(client=client, parent_task_id=inputs[0])
                    else:
                        self.create_work_item(client=client)
                    return self.result
            elif self.target.lower() == "update_work_item":
                if self.check_state:
                        self.id = inputs[0]
                if self.id is None:
                    raise ValueError("You have to specify the id of the work item that you want to modify.")
                else:
                    if self.second_get_inputs_from is not None:
                        print("Our input is {}".format(second_inputs[0]))
                        self.update_work_item(client=client, parent_task_id=second_inputs[0])
                    else:
                        self.update_work_item(client=client)
                    return self.result
            elif self.target.lower() == "delete_work_item":
                if self.id is not None:
                    self.delete_work_item(client=client)
            elif self.target.lower() == "repo" :
                # TODO
                return "This target is in progress"
            elif self.target.lower() == "boards" :
                # TODO
                return "This target is in progress"
            elif self.target.lower() == "artifacts" :
                # TODO
                return "This target is in progress"
            elif self.target.lower() == "test" :
                return "My var is here"
            elif self.target.lower() == "test_result" :
                new_result = "I got the result from the previuos task. The result is : \n\t" + inputs
                print(new_result)
            else:
                print("\n\n\nTarget variable must be set as one of these;\n\n\twiql, \n\tget_work_item_by_id, \n\tcreate_work_item, \n\tupdate_work_item, \n\tdelete_work_item, \n\trepo, \n\tboards, \n\tartifacts.\n\n\n.")


        

