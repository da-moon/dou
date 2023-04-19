"""
Routes and views for the flask application.
"""
import asyncio
import sys

# flask dependencies
from flask import(
    Flask,
    request,
    Response
)

# bot framework libs
from botbuilder.core import (
    BotFrameworkAdapter,
    BotFrameworkAdapterSettings,
    TurnContext,
)

from botbuilder.schema import Activity
from vbot.bot import DouBot

# GLOBALS AND MODULES INITIALIZES
JSON_TYPE="application/json"
SETTINGS = BotFrameworkAdapterSettings("","")
ADAPTER = BotFrameworkAdapter(SETTINGS) 
LOOP = asyncio.get_event_loop()
dou_bot = DouBot()
app = Flask(__name__)
wsgi_app = app.wsgi_app

@app.route("/api/messages", methods=["POST"])
def messages():
    # accept json only
    if JSON_TYPE not in request.headers["Content-Type"]:
        return Response(status=415)
    
    body = request.json
    activity = Activity().deserialize(body)
    auth_header = ""
    
    auth_name = "Authorization"

    if auth_name  in request.headers:
        auth_header = request.header[auth_name]

    async def foo(ctx):
        await dou_bot.on_turn(ctx)

    task = LOOP.create_task(
            ADAPTER.process_activity(activity, auth_header, foo)
        )

    LOOP.run_until_complete(task)
    