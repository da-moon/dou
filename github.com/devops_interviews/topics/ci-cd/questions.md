## CI/CD Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

### Cheat Sheet

![CI/CD Cheat Sheet](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/ci-cd-cheat-sheet.png)

### Questions

- **Basic questions**:
    - What is Continuous Integration??
        + Continuous Integration (CI) is a development practice that requires developers to integrate code into a shared repository several times a day. Each check-in is then verified by an automated build, allowing teams to detect problems early.<br>The basic idea of CI is to build and integrate the software frequently. This can be as frequent as every code check-in. Batched integration is also common whereby the software may be integrated when a series of code check-ins have happened, such as when a feature is complete.
    - What is Continous Delivery?
        + Continuous Delivery is a process where integrated code is pushed to specific environments. It ensures code delivery to specified infrastructure environment. It starts after continuous integration. CD ensures the automation of delivering new code with minimum efforts. Some extra checks are also performed during CD process such as performance test for production environment.
    - What is Continous Deployment?
    	+ Continuous deployment is most critical stage in pipeline. In this process code changes are automatically deployed to production environment where end customers or users are using the application. It is achieved by taking the benefit of continuous delivery by automating new stage (Production) in the pipeline. There is very less human interaction at this stage and it helps to reduce delay in making code changes live.
    - What is the difference between Continous Delivery and Continous Deployment?
    	+ Continuous Deployment - refers a system that allows deployment of every new changes that comes in source code from a developer.
		+ Continuous Delivery - refers the automation of entire software release process.
		+ ![CI/CD example ](https://github.com/DigitalOnUs/devops_interviews/blob/master/topics/ci-cd/ci-cd-example.png)

	- Tell us some CI/CD tools?
		+ MS Azure DevOps
		+ Microsoft VSTS
		+ Bamboo
		+ GitLab
		+ Codeship
		+ Codefresh
		+ TeamCity
		+ GitHub Actions
		+ Tracis CI

	- What is GitOps?
		+ “GitOps is an operational framework that takes DevOps best practices used for application development such as version control, collaboration, compliance, and CI/CD tooling, and applies them to infrastructure automation”.

	- Explain the difference phases inside the DevOps lifecycle:
		+ Plan – In this stage, all the requirements of the project and everything regarding the project like time for each stage, cost, etc are discussed. This will help everyone in the team to get a brief idea about the project.
		+ Code – The code is written over here according to the client’s requirements. Here codes are written in the form of small codes called units.
		+ Build – Building of the units is done in this step.
		+ Test – Testing is done in this stage and if there are mistakes found it is returned for re-build.
		+ Integrate – All the units of the codes are integrated into this step.
		+ Deploy – codeDevOpsNow is deployed in this step on the client’s environment.
		+ Operate – Operations are performed on the code if required.
		+ Monitor – Monitoring of the application is done over here in the client’s environment.
		+ ![DevOps Life cycle  ](https://github.com/DigitalOnUs/devops_interviews/blob/master/topics/ci-cd/devops-life-cycle.jpeg)

	- Give us an example of a CI/CD pipeline:
		+ Developers develop the code and this source code is managed by Version Control System tools like Git etc.
		+ Developers send this code to the Git repository and any changes made in the code is committed to this Repository.
		+ Jenkins or Github Actions pulls this code from the repository using the Git plugin and build it using tools like Ant or Maven or Bazel.
		+ Configuration management tools like puppet or ansible deploys & provisions testing environment and then Jenkins releases this code on the test environment on which testing is done using tools like selenium.
		+ Once the code is tested, Jenkins send it for deployment on the production server (even production server is provisioned & maintained by tools like puppet).
		+ After deployment It is continuously monitored by tools like Cloudwatch in aws, Nagios or data dog.



- **Advance questions**:
    - What are the success factors for Continuous Integration?
    	+ Implementing the tools for Continuous Integration is the easy part. Making best use of Continuous Integration is the complex bit. The following aspects are needed to be considered:
			+ How often is code committed? If code is committed once a day or week, the CI setup is under-utilized. Defeats the purpose of CI.
			+ How is a failure treated? Is immediate action taken? Does failures promote fun in the team?
			+ What steps are in continuous integration? More steps in continuous integration means more stability.
			+ Compilation
			+ Unit Tests
			+ Code Quality Gates
			+ Integration Tests
			+ Deployment
			+ Chain Tests
			+ More steps in continuous integration might make it take more time but results in more stable application. A trade-off needs to be made.
			+ Run Steps a,b,c on a commit.
			+ Run Steps d & e once every 3 hours.
			+ How long does a Continuous Integration build run for?:  One option to reduce time taken and ensure we have immediate feedback is to split the long running tests into a separate build which runs less often.

	- What tools for Continuous Integration you know and what´s their function on the CI pipeline?
		+ Different tools for supporting Continuous Integration are Hudson, Jenkins, Bamboo, Team City. Jenkins is the most popular one currently. They provide integration with:
			* Version control systems (e.g.Git, SVN, CVs, etc.)
			* Build tools (e.g. Ant, Maven, Gradle, etc.)
			* Test automation Tools (Selenium, QTP, fitnesse, SAHI, JMeter, etc)
			* Audit Tools (e.g. Sonar, Nuendo, Codepro AnalytiX,  etc)
			* Repository Management Tools (e.g. Nexus, artifactory, archiva, etc.)

	- What are the principles of "Continuous Integration"?
		+ Maintain a code repository: Code should be maintained in a Version Control such as Git, CVS, SVN, VSS, ClearCase etc., which could allow multiple developers to work collaboratively in parallel by Versioning the Files (code).<br>Automate the build: Should Have scheduled automated builds by using the tools like "Hudson, Jenkins, TeamCity, CruiseControl" etc., which could automatically checkout(Get) the code from Code Repository and build.<br>Make the build self-testing: During the build process, after compiling the code we can make the Code Self-Testing by executing the Unit Test cases such as JUNIT or Cactus or EasyMock etc. and confirms that nothings is broken.<br>Automate deployment: Once build and self-testing process is done, we should have automated Deployments.

	- Tell us some benefits of CI/CD:
		+ Faster identification and resolution of defects : CI/CD allows an elegant way to establish the appropriate quality gates in the development and testing process. A fast feedback loop to the developers ensures that bugs are addressed early in the development cycle
		+ Reduced overhead cost : Finding a bug at the development stage is the cheapest possible way to find it. If the same bug was to be fixed in any other environment, it would cost more. CI/CD requires some upfront overhead cost, but these are more than offset by the time and expense saved along the way.
		+ Better quality assurance : CI/CD enables QA teams to release deployable software at any point in time. Without it, projects are prone to delayed releases because of unforeseen issues which arise at any point in the traditional development and test process.
		+ Reduced assumptions : CI/CD replaces testing assumptions with knowledge, thereby eliminating all cross-platform errors at the development stage.
		+ Faster time to market : Faster test and QA cycles enable organizations to get quality products and services to market faster and more efficiently.
		+ Software health measurability : By establishing continuous testing into the automated integration process, software health attributes such as complexity can be tracked over time.
		+ Better project visibility : Frequent code integration provides the opportunity to identify trends in build success and failure and make informed decisions to address them. With CI/CD, dev and test teams can access real-time data on the code quality metrics to innovate new improvements and support decisions.
