import os

from airflow.utils import timezone

DEFAULT_DATE = timezone.datetime(2016, 1, 1)
DAGS_FOLDER = os.path.join(os.path.dirname(os.path.realpath(__file__)), './dags')
