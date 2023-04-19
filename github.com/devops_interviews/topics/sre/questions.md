 ## SRE (Site Reliability Engineering) Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

- What is the difference between DevOps and SRE?
	- Reducing Organizational Silos:
		+ SRE treats Ops more like a software engineering problem.
		+ DevOps focuses on both Dev and Ops departments to bridge these two worlds.
	- Leveraging Tooling and Automation:
		+ SRE is focused on embracing consistent technologies and information access across the IT teams. 
		+ DevOps focuses on automation and the adoption of technology.
	- Measuring Everything:
		+ DevOps is primarily focused on the process performance and results achieved with the feedback loop to realize continuous improvement.
		+ SRE requires measurement of SLOs as the dominant metrics since the framework observes Ops problems as software engineering problems.

- What can you tell me about SLO and its meaning?
	- SRE begins with the idea that availability is a prerequisite for success. An unavailable system can’t perform its function and will fail by default. Availability, in SRE terms, defines whether a system is able to fulfill its intended function at a point in time. We wanted to set a precise numerical target for system availability. We term this target the availability _Service-Level Objective (SLO)_ of our system. Any future discussion about whether the system is running reliably and if any design or architectural changes to it are needed must be framed in terms of our system continuing to meet this SLO.


- What can you tell me about SLA and its meaning?
 	- An SLA (_Service-Level Agreement_) normally involves a promise to a service user that the service availability SLO should meet a certain level over a certain period. Failing to do so then results in some kind of penalty. This might be a partial refund of the service subscription fee paid by customers for that period, or additional subscription time added for free. Going out of SLO will hurt the service team, so they will push hard to stay within SLO.

- What can you tell me about SLA and its meaning?
	- Service-Level Indicator (SLI) is a direct measurement of a service’s behavior, defined as the frequency of successful probes of our system. When we evaluate whether our system has been running within SLO for the past week, we look at the SLI to get the service availability percentage.

- What is TOIL?
	- In SRE the kind of work tied to running a production service that tends to be manual, repetitive, automatable, tactical, devoid of enduring value, and that scales linearly as a service grows. 

- What is Error Budgets? And for what error budgets is used?
	- Error budget defines the maximum amount of time a technical system can fail without contractual consequences. Error budget encourages the teams to minimize real incidents and maximize innovation by taking risks within acceptable limits.

- Define the Error budget policy?
	- An error budget policy demonstrates how a business decides to trade off reliability work against other feature work when SLO indicates a service is not reliable enough.

- What is post morten?
	- A postmortem is the act of holding a retrospective after a service incident. Depending on the organization, a postmortem is called by many names—retrospective, root cause analysis (RCA), incident review, and others. The idea is to create a document that records why an incident happened and discuss what happened with those involved.

- Tell some common postmortem triggers?
	- User-visible downtime or degradation beyond a certain threshold
	- Data loss of any kind
	- On-call engineer intervention (release rollback, rerouting of traffic, etc.)
	- A resolution time above some threshold
	- A monitoring failure (which usually implies manual incident discovery)


- If you have ticket about client saying that they can't connect to the application url, how you troubleshoot that, what do you monitor to get the cause for failure?
	- You are looking for their thinking process, their organization, and how methodical they are in finding problem sources. You are also looking for how creative they can be in solving them. He needs to mention at least some unix commands to get the ports, connection protocols (TCP/IP), availabilty, etc.

- What is observability, how to improve organizations systems observability?
	- Observability is basically a conversation around the measurement and instrument of an organization.
	Understand what types of data flow from an environment, and which of those data types are relevant and useful to your observability goals.
	Get a clear vision of what a team cares about and figure out how your strategy is making sense of data by distilling, curating, transforming it into actionable insights into the performance of your systems.
	Observability offer potentially useful clues about an organization’s DevOps maturity level.

