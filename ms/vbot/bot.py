# dummy echo bot
class DouBot(object):
    async def on_turn(self, context):
        if context.activity.type == "message" and context.activity.text:
            # dummy echo now
            echoBack = "Got from you %s" % (context.activity.text)
            await context.send_activity(echoBack)