## DevOps Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

### Cheat Sheet

![DevOps Cheat Sheet-1](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/devops-cheat-sheet-1.png)
![DevOps Cheat Sheet-2](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/devops-cheat-sheet-2.png)

### Questions

- **Basic questions**:
    - What’s the definition of DevOps for you?
        + DevOps is the combination of cultural philosophies, practices, and tools that increases an organization's ability to deliver applications and services at high velocity: evolving and improving products at a faster pace than organizations using traditional software development and infrastructure management processes.
    - What DevOps tools have you worked with?
        + CI/CD tools (jenkins, travis, teamcity, bamboo, github actions).
        + Configuration management (puppet, chef, ansible, cfengine)
        + Orchestration Tools (Kubernetes, Nomad, Openshift, Docker swarm, minukube).
        + Monitoring tools (Prometheus, kibana, splunk, datadog, pagerduty, new relic, app dynamics).
        + Virtualization and containerization (AWS, OpenStack, vagrant, docker) and many more.
    - What’s VCS and which VCSs you know?
        + Version Control System and is the base for the implementation of a SCM strategy like:
            * GIT
            * SVN
            * CVS

    - What is SCM?
        + Software Configuration Management. Is the task of tracking and controlling changes in the software, part of the larger cross-disciplinary field of configuration management.[2] SCM practices include revision control and the establishment of baselines. If something goes wrong, SCM can determine what was changed and who changed it. If a configuration is working well, SCM can determine how to replicate it across many hosts.


- **Advance questions**:
    - What are the steps involved in project deployment?
        + Normally a deployment process consists of following steps:
            * Check-in the code from all projects in progress into the SVN or source code repository and tag it.
            * Download the complete source code from SVN.
            * Build the application.
            * Store the build output either WAR or EAR file to a common network location.
            * Get the file from network and deploy the file to the production site.
            * Updated the documentation with date and updated version number of the application.
    - What do you understand for ERM?
        + Enterprise Release Management (ERM) is an emerging set of practices designed to support enterprise change initiatives and software delivery across multiple projects within large organizations.  ERM is the management of the software delivery lifecycle across multiple projects and departments within a large organization - the orchestration of activities and resources across multiple, interdependent software releases and change initiatives to deliver software at scale while managing both the technical and organizational complications that accompany delivering changes to enterprise-scale, composite systems within a large organization.

    - Mention 3 benefits of a Release Management.
        + Efficiency  – Reducing the time it takes to find, fix, and deliver reliable, quality software.
        + Productivity – Teams can focus on more important items then trying to figure out what version or steps have caused an outage.
        + Risk Reduction – The ability to identify the what, when, where, and how for a release.
        + Collaboration between teams – Opening a platform for the team to discuss blocking issues by using definite and transparent processes.
        + Configuration management – Knowing what environment setting, application requirements, and dependences exist in the production, test, and development environments.
    - Order the following types of tools in the order they should be deployed when starting a   DevOps Practice: 1) Monitoring(Nagios, Zenoss, Etc), 2) Configuration Mgmt(Puppet, Chef, SaltStack,Ansible), 3) Wiki and or a Bug Tracking tool(MediaWiki, Bugzilla,etc), 4) Continuous Integration/Deployment Tools(Jenkins, TravisCi, etc)
        + 1. Configuration Mgmt
        + 2) CI/CD
        + 3) Monitoring
        + 4) Wiki / Bug Tracking 
   