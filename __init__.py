import logging
import azure.functions as func
import os
import json
import asyncio

from azure.eventhub.aio import EventHubProducerClient
from azure.eventhub import EventData
from datetime import datetime

class EventProducer:
    _MAX_NUM_RETRIES: int = 4
    _TIMEOUT_SEC: int = 5
    _KEEP_ALIVE_INTERVAL: int = 30

    def __init__(self, conn_str):
        self.client = EventHubProducerClient.from_connection_string(
            conn_str,
            retry_total=EventProducer._MAX_NUM_RETRIES,
            logging_enable=True,
            keep_alive_interval=EventProducer._KEEP_ALIVE_INTERVAL  # send heartbeat to the service to keep connection alive every 30s
        )
        self.lock = asyncio.Lock()

    async def produce(self, data):
        try:
            async with self.lock:
                logging.info(f'Start sending batch')
                await self.client.send_batch([EventData(data)], timeout=EventProducer._TIMEOUT_SEC)
                logging.info(f'Done sending batch')
            return
        except Exception as e:
            logging.error(f'Unexpected exception while sending data: {e}')
            logging.exception(e)

        logging.error('Unable to send the data: retries exhausted')

# producer singleton
conn_str = os.getenv("TIS_CONNECTION_STRING")
producer = EventProducer(conn_str)

async def main(event: func.EventHubEvent):
    for e in event:
        body = json.loads(e.get_body())
        source = e.metadata["PropertiesArray"][0]["cloudEvents:source"]
        dt = datetime.now()
        ts = dt.strftime("%Y-%m-%dT%H:%M:%SZ")
        result = {
            "dtId": source,
            "temperature": body["temperature"],
            "humidity": body["humidity"],
            "timestamp": ts
        }
        
        await producer.produce(json.dumps(result))
