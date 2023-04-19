# import git
import os
import shutil
import random
import string
import re
# import consul
import json
# import jira


class Helpers():
    """
    This class is used to perform native fewknow
    helper tasks for airflow dag creation
    """

    def __init__(self,
                 *args,
                 **kwargs):
        """
        Intialize Helpers
        """

    def _get_project_name(self, db, path):

        full_path = path + "/" + db + "/params.yml"
        ##print(full_path)
        for line in open(full_path).readlines():
            if re.match("PROJECT", line):
                ##print(line)
                project = line.rsplit(':',)[1].strip()
                ##print(project)
                return project

    def _get_database_name(self, db, path):
        full_path = path + "/" + db + "/params.yml"
        for line in open(full_path).readlines():
            if re.match("LIQUIBASE_DATABASE", line):
                database_name = line.rsplit(':',)[1].strip()
                return database_name

    def _randomString(self):
        """Generate a random string of fixed length """
        letters = string.ascii_lowercase
        x = random.choice(letters) + random.choice(letters) + random.choice(letters)

        ##print(x)
        return x

    # def process_databases(self,**kwargs):
    #     """
    #     This should return a list of database pipelines that we currently have in our system.
    #     """
    #     ## pull devops.concourseci repo
    #     filename = self._randomString()
    #     url = "https://bitbucket.org/fewknow/devops.concourseci.git"
    #     repo = git.Repo.clone_from(url, os.path.join(filename), branch='master')

    #     path = "{f}/pipelines/postgres_db_deploys".format(f=filename)
    #     ## parse over the /pipeline/postgres_db_deploys
    #     directories = next(os.walk(path))[1]

    #     pipelines = []

    #     for db in directories:
    #         project = self._get_project_name(db,path)
    #         database_name = self._get_database_name(db,path)
    #         tuple=(db,project,database_name)
    #         ##print(tuple)
    #         pipelines.append(tuple)

    #     ##print(pipelines)

    #     ##print("need to delete")
    #     ##print(filename)

    #     shutil.rmtree(filename)

    #     return pipelines

    # def get_schedules(self, consul_key, host):
    #     #get keys from consul

    #     c = consul.Consul(host=host, port=8500)
    #     primary_key=consul_key
    #     # poll a key for updates
    #     scheduler_value = c.kv.get(primary_key, keys=True, separator='/')
    #     schedules = [k for k in scheduler_value[1] if k != primary_key]

    #     jobs = []
    #     #schedules.remove(primary_key)
    #     for schedule in schedules:
    #         schedule_endpoint = c.kv.get(schedule + "endpoint")
    #         #print("ENDPOINT")
    #         endpoint = schedule_endpoint[1]['Value'].decode('utf-8')
    #         #print(endpoint)
    #         #print("SCHEDULE")
    #         schedule_schedule = c.kv.get(schedule + "schedule")
    #         sc = schedule_schedule[1]['Value'].decode('utf-8')
    #         #print(sc)
    #         #print("OPTIONS")
    #         schedule_options = c.kv.get(schedule + "options")
    #         #print(schedule_options)
    #         options = schedule_options[1]['Value'].decode('utf-8')
    #         #print(options)
    #         schedule_job_type = c.kv.get(schedule + "job_type")
    #         #print(schedule_job_type)
    #         job_type = schedule_job_type[1]['Value'].decode('utf-8')
    #         try:
    #             schedule_schedule = c.kv.get(schedule + "user_id")
    #             userId = schedule_schedule[1]['Value'].decode('utf-8')
    #         except TypeError:
    #             userId = "KSADMIN"
    #         #print(job_type)

    #         job_name=schedule.replace(primary_key,'').strip("/")
    #         #print(job_name)
    #         job = {'job_name' : job_name, 'schedule' : sc, 'endpoint' : endpoint, 'options' : options, 'job_type' : job_type, 'user_id': userId}
    #         jobs.append(json.dumps(job))

    #     #print(jobs)
    #     return jobs

    # def get_children_keys(self, consul_key, host):
    #     c = consul.Consul(host=host, port=8500)
    #     primary_key=consul_key
    #     # poll a key for updates
    #     keys = c.kv.get(primary_key, keys=True, separator='/')
    #     keys = [k for k in keys[1] if k != primary_key]
    #     print(keys)
    #     return keys


#FOR TESTING LOCLALLY
# test = Helpers()
# tenants = test.get_children_keys(consul_key='config/scheduler/', host='localhost')

# for tenant in tenants:
#     key=tenant + "jobs/"
#     print(key)

# schedule = test.get_schedules(consul_key='config/scheduler/DDVA/jobs/', host='localhost')

# print(schedule)


# d = test.process_databases(bitbucketuser="cv-devops",bitbucketpassword="")
# print(d)
