from ast import operator
import base64
import json
import logging
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
                
        parameters = ["timestamp", "Device_ID", "State_Code_Derived", "State_Cycling", "State_Setup", "State_Non_Prod", "State_Stopped", "State_Breakdown", "State_Tooling_Loss",
         "State_Unplanned_Down", "State_Net_Available", "State_Blocked", "Sub_State_Code", "Event_Code", "State_Desc", "Sub_State_Desc", "Event_Desc", "State_Code"]
        action = "add"
        if shouldBeReplaced(parameters, digital_twin["$metadata"]):
            action = "replace"

        # Get data transformed

        logging.info("getting data transformed")

        transformedData = transformData(body)

        logging.info("event %s: event transformedData(%s)", event_id, transformedData)


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
            # Transformed data
            {
                "op": action,
                "path": "/State_Code_Derived",
                "value": transformedData["stateCodeDerived"]
            },
            {
                "op": action,
                "path": "/State_Cycling",
                "value": transformedData["stateCycling"]
            },
            {
                "op": action,
                "path": "/State_Setup",
                "value": transformedData["stateSetup"]
            },
            {
                "op": action,
                "path": "/State_Non_Prod",
                "value": transformedData["stateNonProd"]
            },
            {
                "op": action,
                "path": "/State_Stopped",
                "value": transformedData["stateStopped"]
            },
            {
                "op": action,
                "path": "/State_Breakdown",
                "value": transformedData["stateBreakdown"]
            },
            {
                "op": action,
                "path": "/State_Tooling_Loss",
                "value": transformedData["stateToolingLoss"]
            },
            {
                "op": action,
                "path": "/State_Unplanned_Down",
                "value": transformedData["stateUnplannedDown"]
            },
            {
                "op": action,
                "path": "/State_Net_Available",
                "value": transformedData["stateNetAvailable"] if "stateNetAvailable" in transformedData.keys() else False
            },
            {
                "op": action,
                "path": "/State_Blocked",
                "value": transformedData["stateBlocked"]
            },
            {
                "op": action,
                "path": "/Sub_State_Code",
                "value": body["Sub_State_Code"]
            },
            {
                "op": action,
                "path": "/Event_Code",
                "value": body["Event_Code"]
            },
            {
                "op": action,
                "path": "/State_Desc",
                "value": body["State_Desc"]
            },
            {
                "op": action,
                "path": "/Sub_State_Desc",
                "value": body["Sub_State_Desc"]
            },
            {
                "op": action,
                "path": "/Event_Desc",
                "value": body["Event_Desc"]
            },
            {
                "op": action,
                "path": "/State_Code",
                "value": body["State_Code"]
            },
        ]

        service_client.update_digital_twin(device_id, update)
        logging.info("event %s: device %s updated", event_id, device_id)

        # Update the json body with transformed data
        body["State_Code_Derived"] = transformedData["stateCodeDerived"]
        body["State_Cycling"] = transformedData["stateCycling"]
        body["State_Setup"] = transformedData["stateSetup"]
        body["State_Non_Prod"] = transformedData["stateNonProd"]
        body["State_Stopped"] = transformedData["stateStopped"]
        body["State_Breakdown"] = transformedData["stateBreakdown"]
        body["State_Tooling_Loss"] = transformedData["stateToolingLoss"]
        body["State_Unplanned_Down"] = transformedData["stateUnplannedDown"]
        body["State_Net_Available"] = transformedData["stateNetAvailable"] if "stateNetAvailable" in transformedData.keys() else False
        body["State_Blocked"] = transformedData["stateBlocked"]


        service_client.publish_telemetry(device_id, body)
        logging.info("event %s: device %s telemetry published", event_id, device_id)

    else:
        logging.error("event %s: device with ID %s does not exist", event_id, device_id)


def transformData(jsonBody):
    dict = {}
    logging.info("transforming data ...")
    
    if "State_Code" in jsonBody:
        dict["stateCodeDerived"] = jsonBody["State_Code"] * 1
        dict["stateCycling"] = dict["stateCodeDerived"] == 1000
        dict["stateSetup"] = dict["stateCodeDerived"] == 1500
        dict["stateNonProd"] = dict["stateCodeDerived"] == 2000
        dict["stateStopped"] = dict["stateCodeDerived"] == 3000
        dict["stateBreakdown"] = dict["stateCodeDerived"] == 4000
        dict["stateToolingLoss"] = dict["stateCodeDerived"] == 7000
        dict["stateUnplannedDown"] = True if dict["stateBreakdown"] == True else True if dict["stateStopped"] == True else True if dict["stateSetup"] == True else False

        if "Schedule_Is_Productive" in jsonBody:
            dict["stateNetAvailable"] = True if dict["stateNonProd"] == True else True if jsonBody["Schedule_Is_Productive"] == True else False

    if "Sub_State_Code" in jsonBody:
        dict["stateBlocked"] = jsonBody["Sub_State_Code"] == 3100


    # TODO eventCodePrev
    # TODO eventCodeTimePrev
    # TODO eventDuration
    
    logging.info("transforming data finished")
    return dict

def shouldBeReplaced(values, compare):
    for value in values:
        if not value in compare:
            return False
    return True