from ast import operator
import base64
import json
import logging
from operator import truediv
from tabnanny import check

from azure.identity import DefaultAzureCredential
from azure.digitaltwins.core import DigitalTwinsClient

import azure.functions as func
import os
import json
from azure.servicebus import ServiceBusClient

def main(event: func.EventGridEvent):

    event_id = event.id

    CONNECTION_STR = os.getenv("AZURE_SERVICE_BUS_CONNECTION_STRING")
    QUEUE_NAME = os.getenv("AZURE_SERVICE_BUS_QUEUE_NAME")

    logging.info("event %s: started", event_id)

    servicebus_client = ServiceBusClient.from_connection_string(conn_str=CONNECTION_STR, logging_enable=False)
    
    listMsg = []

    with servicebus_client:
        # get the Queue Receiver object for the queue
        receiver = servicebus_client.get_queue_receiver(queue_name=QUEUE_NAME, max_wait_time=5)
        with receiver:
            for msg in receiver:
                listMsg.append(msg)
                # complete the message so that the message is removed from the queue
                receiver.complete_message(msg)

    for msg in listMsg:
        logging.info("msg: %s", str(msg))
       
        saveDataToDigitalTwin(event_id, str(msg))

    

def saveDataToDigitalTwin(event_id, msg):
    url = os.getenv("AZURE_ADT_URL")
    credential = DefaultAzureCredential()
    service_client = DigitalTwinsClient(url, credential)
    logging.info("event %s: DigitalTwins credentials created", event_id)

    body = json.loads(msg)
    
    logging.info("event %s: event data body(%s)", event_id, json.dumps(body))

    device_id = body["Device_ID"]

    digital_twin = service_client.get_digital_twin(str(device_id))

    if digital_twin:
        logging.debug("event %s digitaltwin info %s", device_id, json.dumps(digital_twin))
        
        parameters = ["timestamp", "Device_ID", "Units_Total", "Units_Bad", "Units_Good"]
        action = "add"
        if shouldBeReplaced(parameters, digital_twin["$metadata"]):
            action = "replace"

        logging.info("event %s action %s", event_id, action)
        update = [
            # Properties
            {
                "op": action,
                "path": "/timestamp",
                "value": body["timestamp"]
            },
            {
                "op": action,
                "path": "/Device_ID",
                "value": str(body["Device_ID"])
            },
            {
                "op": action,
                "path": "/Units_Total",
                "value": body["Units_Total"]
            },
            {
                "op": action,
                "path": "/Units_Bad",
                "value": body["Units_Bad"]
            },
            {
                "op": action,
                "path": "/Units_Good",
                "value": body["Units_Good"]
            },
        ]

        service_client.update_digital_twin(device_id, update)
        logging.info("event %s: device %s updated", event_id, device_id)

        service_client.publish_telemetry(device_id, body)
        logging.info("event %s: device %s telemetry published", event_id, device_id)

    else:
        logging.error("event %s: device with ID %s does not exist", event_id, device_id)

def shouldBeReplaced(values, compare):
    for value in values:
        if not value in compare:
            return False
    return True