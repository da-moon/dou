# Observability

At this point, we had seen terms like: `data pipelines`, `orchestration`, `infrastructure`, `storage`, etc.

All of those items might eventually face different conditions that could cause failures or not-expected behavior.

Consider the  following scenario:

```
You already have a data-pipelines scheduled to be run every hour. 
This pipeline consumes from an API and store the content on a single file, where the name of the file will contain the 
date-time of the execution.

There are also some teams that uses that file as input of their systems, but they consume your output in a daily-basis.

Everything is working fine, but sudenly you see same messages from downstream teams complaing because they 
dont found data for yesterday's date. 
```

Since your process is executed hourly and consumers (downstream processes) are daily. 
There are, at least, 24 executions that were recently failing and causing empty output of your process.

Let's take some time. 

Can you think what are all the possible reasons that might cause this issue? 

Let's list a set of possible options to discus about them (assuming we don't have any observability integration):
- Infrastructure issue: Host, network, etc regarding the host for processing and/or orchestration
- Source issue: For some reason, our input API is down, not accessible, returning timeout, etc
- Data issue: Similarly, we might have updates on the data produced by the input API, regarding schema, values, formatting, etc.
- Processing issue: Within the code scope, we might face edge-cases that cause run-time exception, causing that output is not generated.
- Output issue: In the same way than the data issue, since we have many dependencies (input, output, lookups, etc), same issues can happen on those entities as well (network, availability, etc.) 

These are only few of the points that might cause the issue, however there could be even more.
Troubleshooting them manually is not optimal, right? But the problem is not only that, the real issue is that we must 
avoid reaching that point where we need to fix something. Instead, we should have an automated way to identify (and if possible, prevent) 
those issues and communicate them to the proper people/team to take actions.

That is where observability plays.

We should take care of the right behavior on infrastructure and application level, using metrics and some other integrations 
to make a system smart and automated enough.

All of the cloud providers offer different options to apply observability, but there are also some services like Datadog that helps on that task.

## Activity
- Research about data-pipelines observability services (apart of basic the cloud-provider services). Which one more looks interesting?
