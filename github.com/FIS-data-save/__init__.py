import base64
import json
import logging

from azure.identity import DefaultAzureCredential
from azure.digitaltwins.core import DigitalTwinsClient

import azure.functions as func
import os
import json



def main(event: func.EventGridEvent):

    url = os.getenv("AZURE_ADT_URL")
    event_id = event.id

    logging.info("event %s: started", event_id)

    credential = DefaultAzureCredential()
    service_client = DigitalTwinsClient(url, credential)
    logging.info("event %s: DigitalTwins credentials created", event_id)

    data = event.get_json()

    body = json.loads(base64.b64decode(data["body"]))
    
    logging.debug("event %s: event data(%s)", event_id, json.dumps(body))

    device_id = body["deviceId"]
    temperature = body["temperature"]
    humidity = body["humidity"]


    logging.debug("event %s: deviceId(%s)", event_id, device_id)

    digital_twin = service_client.get_digital_twin(device_id)

    if digital_twin:
        logging.debug("event %s digitaltwin info %s", device_id, json.dumps(digital_twin))

        temperature = body["temperature"]
        humidity = body["humidity"] 
        logging.info("event %s: device %s with telemetry (humidity: %s, temperature: %s)", event_id, device_id, humidity, temperature)
        
        action = "add"
        if "humidity" in digital_twin["$metadata"]:
            action = "replace"

        logging.info("event %s action %s", event_id, action)
        update = [
            {
                "op": action,
                "path": "/humidity",
                "value": humidity
            },
            {
                "op": action,
                "path": "/temperature",
                "value": temperature
            }
        ]

        service_client.update_digital_twin(device_id, update)
        logging.info("event %s: device %s updated", event_id, device_id)

        service_client.publish_telemetry(device_id, body)
        logging.info("event %s: device %s telemetry published", event_id, device_id)
        
    else:
        logging.error("event %s: device with ID %s does not exist", event_id, device_id)




