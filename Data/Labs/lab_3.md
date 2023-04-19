# Data Lab 💾

# Practice #3 - ETL orchestration

### Objective:

- Let’s use the code created on the practice #1 and add some updates. Then, using `apache-airflow`, orchestrate a data-pipeline.

__Details:__

1. Using the code from the practice #1, add an extra field (`updated_ts`) that will store the `timestamp` of when the process is executed. So that, this field will let us know when was the last time an entity was updated
2. Develop an `apache-airflow` solution for `data-pipeline` orchestration. Use `astro-CLI` (<https://docs.astronomer.io/astro/>)
3. Create a `DAG` with 4 operators on the below order:
   - `start` (`DummyOperator`) -> 
   - `etl` (`PythonOperator` - this will execute the ETL logic) ->
   - `execution_log` (`PythonOperator` - this should create a file with the status of the etl operator and its execution time) -> 
   - `end` (`DummyOperator`)

__Extras:__
- What happen if there is a timeout while connecting with `azure-services`?
- Is `execution_log` operator executed if `etl` operator fails? Why? Is it possible to make it run regardless of the status of `upstream` operator? 
- How we can set an automatic retry for the operators?
- Is there a way we can get notified in case any operator fails? how? Integration ideas?
  