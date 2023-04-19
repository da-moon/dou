## TroubleShooting Common Questions.

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

Remember that in troubleshooting we are looking for someone that has experience working in production scenarios and dealing not only with software issues, but with clients/tickets issues and real case scenarios. So many of the questions will have different answers so be ready to discuss abouut them.

### Cheat Sheet

![Troubleshoot Cheat Sheet](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/troubleshoot-cheat-sheet.png)


### Questions

- If a user raises a ticket that he's receiving a 500 error on the webpage, How do you troubleshoot it?
	+ Check app server, services of the app, Database, listeners, logs of the app.
- What is the difference between an app server and a web server?
	+ App resides on app server. Web is how the users access the application.
- What are the common web servers?
	+ Apache, Nginx, Tomcat, OpenResty.
- If users recieve 400 error, what would you check?
	+ The webservers logs, connectivity to the web server.
- Tell me an example in which situation  you consider it needs to be escalated?
- Do you like to documment and can you give me an example of that?
- Do you think docummenting the issues and how you resolve them are important?
- What kind of apps have you supported?
- Have you been on an on call schedule ever?
- Thread dumps and core dumps -  when do you take these?
- Scenario...An app consuming most of the CPU... what actions you take?
- Scenario...Monitoring tool...how do you identify the issue? What actions you take?
- CodeLevel analysis? you analyze or get in touch with the Dev team?