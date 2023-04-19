import time
from functools import reduce
from random import random


def move_cars(car_positions):
    return list(map(lambda x: x + 1 if random() > 0.3 else x,
                car_positions))


def output_car(car_name, car_position):
    return f'{car_name.ljust(12)} {("-" * car_position).ljust(7)}|'


def run_step_of_race(state):
    time.sleep(state['step_time'])
    return {'steps': state['steps'],
            'step_time': state['step_time'],
            'car_positions': move_cars(state['car_positions']),
            'car_names': state['car_names']}


def draw(state):
    print()
    print('\n'.join(map(output_car, state['car_names'], state['car_positions'])), end='')
    print()


def race(state):
    draw(state)
    if reduce(lambda start, item: item if item > start else start,
              state['car_positions']) < state['steps']:
        race(run_step_of_race(state))


race({'steps': 7,
      'step_time': 3,
      'car_positions': [1, 1, 1],
      'car_names': ['batmobile', 'meteor', 'turtle van']})

