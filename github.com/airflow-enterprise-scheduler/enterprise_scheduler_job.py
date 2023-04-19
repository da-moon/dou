import os
import json
import time
import requests


def start_service_scheduled_job(tenant, endpoint, timestamp):
    print("Launching job {e} for {t} at {time}".format(e=endpoint, t=tenant, time=timestamp))

    url = endpoint
    headers = {'keyspring.tenant.id': tenant, 'iso.time': timestamp, 'Content-type': 'application/json' }
    response = requests.post(url, headers=headers)

    if response.status_code not in list(range(200,299)):
        raise Exception(response.status_code, response.text)
    else:
        print("Success", response.text)

def start_nomad_scheduled_job(tenant, endpoint, timestamp, job_name):
    print("Launching job {j} with endpoint {e} for {t} at {time}".format(j=job_name, e=endpoint, t=tenant, time=timestamp))

    url = endpoint
    headers = {'keyspring.tenant.id': tenant, 'iso.time': timestamp, 'Content-type': 'application/json' }
    payload = {"jobId" : job_name, "jobMeta": { "TENANT" : tenant, "TIMESTAMP" : timestamp } }
    response = requests.post(url, json=payload, headers=headers)

    if response.status_code not in list(range(200,299)):
        raise Exception(response.status_code, response.text)
    else:
        print("Success", response.text)

def start_airflow_scheduled_job(tenant, endpoint, timestamp):
    print("Launching job {e} for {t} at {time}".format(e=endpoint, t=tenant, time=timestamp))

    url = endpoint
    headers = {'keyspring.tenant.id': tenant, 'iso.time': timestamp, 'Content-type': 'application/json' }
    payload = {"conf": { "TENANT" : tenant, "TIMESTAMP" : timestamp } }
    response = requests.post(url, json=payload, headers=headers)

    if response.status_code not in list(range(200,299)):
        raise Exception(response.status_code, response.text)
    else:
        print("Success", response.text)


if os.environ['NOMAD_META_JOB_TYPE'] == 'service':
    start_service_scheduled_job(os.environ['NOMAD_META_TENANT'],os.environ['NOMAD_META_ENDPOINT'],os.environ['NOMAD_META_TIMESTAMP'])
elif os.environ['NOMAD_META_JOB_TYPE'] == 'nomad':
    start_nomad_scheduled_job(os.environ['NOMAD_META_TENANT'],os.environ['NOMAD_META_ENDPOINT'],os.environ['NOMAD_META_TIMESTAMP'],os.environ['NOMAD_META_JOB_NAME'])
elif os.environ['NOMAD_META_JOB_TYPE'] == 'airflow':
    start_airflow_scheduled_job(os.environ['NOMAD_META_TENANT'],os.environ['NOMAD_META_ENDPOINT'],os.environ['NOMAD_META_TIMESTAMP'])
else:
    print("Job type not found.")
    raise Exception(422, "Missing Job Type")
