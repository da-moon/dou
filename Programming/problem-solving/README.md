# Problem Solving 

## Context

On big-data projects, _right-answer_ __is not enough__.

Most of the projects, will require processing of high volume of data.
A wrong logic on the implementation will cause issues on: memory, disk, cost, performance, etc.

Working on cloud, we should be careful on billing perspective. 

The advantage to work with cloud-services is to optimize costs with the model of pay-as-you-go.
However, we need to use those services in a way to use only what is needed, specially on storage and processing services.

Example of processing:

```text
Suppose that you're working on a data-pipeline that consumes one table and generate 3 different output-tables. 

A wrong design will be to create a single-process for each of the output-tables. 
Instead, you can use the same ETL to read once in-memory and then produce the output (0-1-many).
 
With that, we just pay for one-single execution instead of 3.
```

Similarly, we find scenarios not only on etl/pipeline level, but also the code.
At the end, the core of the performance of a given process, starts from the source-code. 
We need to make sure the logic we implement is efficient enough not only for the happy-path, but also for edge cases.

Example of code-level:

```text
You're working on a function that will receive a python-dictionary.
The input-dictionary will be a representation of events by city (key: city_code, events: list of strings) and a input-string a given city code.
The requirement is to return all the distinct events for that given city_code.

- Stop here some minutes and think about your solution for above scenario - 

One wrong approach would be:
Iterate over the complete dictionary, check on every iteration the city_code and 
then iterate over the events to get the distinct values from there.

Why above approach would be wrong if the output is the expected?

Well, that will produce the right output, however not right on performance perspective.
What would happen if the dict will contain N items? and every node N events? 

One possible solution:
- access directly the dict-item since the city_code is the key on the dict, cast the list into a set to get only the distinct events

That will be more optimized, since the first action is a constant-time/memory action, instead of linear (BigO - algorithm complexity).

But... There is something missing, do you see some edge-case that will break that approach? 
```
    
Example of distributed-data processing:

```text
You're working on a data-pipeline with Apache-Spark, reading from two different tables: sales and stores.

The output should be a table with the data of all the sales for the last year and store information for the `store_id=100`.

Possible approach would be:
1. join (inner) `stores` and `sales` data by `store_key`
2. filter joined dataframe by timestamp for only data within the last year and the store_key=100

What would be the problem for above solution??

Answer: Performance, memory and cost.

It's crucial to define the steps in a way we can reduce processing resources to avoid impact performance and cost.

Solution:
- Filter both dataframes before join (always filter before)
- Use broadcast join, since stores table is tiny enough to fit on executors-memory

Disclaimer: This is scenario is just for illustration. Since technologies like Spark, have smart engine and optimization features that are even re-defining execution plan 
dynamically. This scenario might be even solved by Spark itself (v>=3.0) behind scenes.
```

## How can we improve this skill?

Problem-solving is not just coding, actually, coding is the last part of the process.

We can not code something that we don't understand completely.

So, everything starts from the problem understanding, then design and at the end, implementation.

First time that you face a specific scenario will take time to design a proper solution. Next time you find similar context 
the background that you got that first time will reduce the time to reach the implementation since you're already kind of familiar  
with a possible solution. 

If you read a book of how to become a professional-soccer player, you can not think that after complete the reading you'll 
be able to play a match, right? Same thing happen in everything, in this case, problem-solving.

Only way we can improve problem-solving skill, is by practicing. The good news: there are a lot of places we can 
use for that. Those sites will evaluate not only the answer, but also metrics like: time and memory.

## Recommended resources:
- Python: <https://www.hackerrank.com/domains/python> (FREE)
- Problem-Solving: <https://www.hackerrank.com/domains/algorithms> (FREE)
- Problem-Solving: <https://www.algoexpert.io/product> (PAID)
