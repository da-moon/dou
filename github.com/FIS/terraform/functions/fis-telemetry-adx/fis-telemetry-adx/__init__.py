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
            # send heartbeat to the service to keep connection alive every 30s
            keep_alive_interval=EventProducer._KEEP_ALIVE_INTERVAL
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
conn_str_state = os.getenv("ADX_CONNECTION_STRING_STATE_CODE")
producer_state = EventProducer(conn_str_state)

conn_str_jph = os.getenv("ADX_CONNECTION_STRING_JPH")
producer_jph = EventProducer(conn_str_jph)

conn_str_units = os.getenv("ADX_CONNECTION_STRING_UNITS")
producer_units = EventProducer(conn_str_units)


async def main(event: func.EventHubEvent):
    for e in event:
        body = json.loads(e.get_body())
        logging.info("body, %s", body)
        if "State_Code" in body:
            logging.info(f'Invoking the producer of StateCode')
            await producer_state.produce(json.dumps(body))
        if "JPH_Target" in body:
            logging.info(f'Invoking the producer of JPH')
            await producer_jph.produce(json.dumps(body))
        if "Units_Total" in body:
            logging.info(f'Invoking the producer of Units')
            await producer_units.produce(json.dumps(body))
