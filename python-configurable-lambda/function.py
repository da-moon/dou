#!/usr/bin/env python3

"""Handlers that can be used to develop the Spinnaker Lambda integration.
"""


import random

def simple_ps_handler(event, ctx):
    """The simplest lambda handler for the PS team.

    Args:
        event: dictionary of the form {'thing': 'value'}
        ctx: the context for this lambda execution

    Returns:
        A string representation of 'thing' going ps!
    """
    return f"{event['thing'].title()} goes ps!"

class FailureOutOfRange(Exception):
    """Used by the intermittent_ps_handler to signal execution failure."""
    pass

class IntermittentFailure(Exception):
    """Used by the intermittent_ps_handler to signal intermittent failure."""
    pass

def intermittent_ps_handler(event, ctx):
    """A lambda that fails sometimes.

    Args:
        event: dictionary of the form {'failureRate': double, 'thing': str}
                where the double value is between 0.0 and 1.0. If not
                provided, fail all the time!
        ctx: the context for this lambda execution

    Raises:
        FailureOutOfRange if the failureRate is out of bounds.
        IntermittentFailure if the lambda 'randomly' failed.

    Returns:
        A string representation of the 'thing' going ps!
    """
    failure_rate = event.get('failureRate', -0.1)

    if failure_rate < 0.0 or failure_rate > 1.0:
        raise FailureOutOfRange

    if random.uniform(0.0, 1.0) < failure_rate:
        raise IntermittentFailure("I randomly failed!")

    thing = event.get('thing', 'ps')
    return f"{thing.title()} goes ps!"
