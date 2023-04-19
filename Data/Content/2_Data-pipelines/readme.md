# Data pipelines

A data-pipeline is a well-defined set of steps to consume, process and store data.

Example:
- The process that reads data from transactional-sales database and create a bimestral-report.
- The process that reads real-time data from a queue-service and store it on a no-sql database  

Depending on the applied logic, we might have different categories of this process at atomic-level:
- ETL
- ELT
- EL

Also, based on how they are executed, we can categorize them as:
- batch processing (scheduled and/or adhoc runs) 
- streaming (real-time, near-real-time)

Since the technology is in constant evolution, and now with multiple options for cloud, there are also 
different services that help us on the infrastructure, provisioning and management of services to process data depending 
on the project needs.

Example of technology evolution:

- Hadoop mapreduce (in On-premise hadoop ecosystem) -> Apache Spark (in On-premise hadoop ecosystem) -> Apache Spark in cloud-cluster -> Serverless Apache Spark

## Development

Now, how can we develop a data pipeline? A lot of options!

The difference compared some years ago, is the options we have, starting from the core: programming languages.

While some years ago we used to see mostly SQL scripts to perform this kind of process, now we have the chance to work 
with more flexible and powerful programming languages like Python, Scala and Java.

The option to work, for example, with Apache Spark is available with python, java, Scala.

So, with the introduction of programming languages to these processes we can take advantage of OOP and FP, introduce quality steps 
like unit testing, integration testing and regression testing in a much easier way than older technologies. 

The options to integrate not only frameworks, but also methodologies is totally open. Depending on the project we can 
even introduce TDD or BDD to our development workflow.

Most used programming languages for data-pipelines development:
- Python
- Scala
- Java

Most used processing technologies:
- Apache Spark
- Apache beam
- dbt

## Orchestration

For pipelines that will be executed in a fixed schedule or adhoc execution, are considered batch jobs.

Since some the pipeline itself could be a set or more ETL/ELT/EL or any other sub-process, we need to have a 
way to determine dependencies, order and rules among them.

There are two concepts we need to visualize at this point:

1. A data-pipeline is a set of defined steps with a given start, end and dependencies
2. Every step on that data-pipeline would represent an atomic-process (EL/ETL/ELT)

So, there are technologies, like Apache-airflow, that help us to define above items programmatically.
Then, in apache-airflow scope we can say that the item #1 on the above list is a `DAG` and every step will be a `task`.

Apache-airflow is coded in python, so there is no limit to add or include whatever integration and/or functionality we 
require as part of our workflow. In the same way, dynamic changes, parametrization, etc. 

__Extras:__

- If you want to start with airflow, it's not required to install it directly, you can use `astro-cli` for a dockerized solution: https://docs.astronomer.io/astro/cli/overview
- Start creating a couple of sample DAG's in airflow
- Research about technologies that uses airflow as part of the solution (example: optimus <https://github.com/odpf/optimus>)
