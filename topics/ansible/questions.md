## Ansible Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

### Cheat Sheet

![Ansible Cheat Sheet](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/ansible-cheat-sheet.png)

### Questions

- **Basic questions**:
    - What is configuration management?
        + Configuration management is a process for maintaining computer systems, servers, and software in a desired, consistent state. It's a way to make sure that a system performs as it's expected to as changes are made over time.
    - What is Ansible and what is used for?
        + Ansible is a configuration management system. It is used to set up and manage infrastructure and applications. It allows users to deploy and update applications using SSH, without needing to install an agent on a remote system.
    - What are the features of Ansible?
        + Agentless: Unlike Puppet or Chef, there is no software or agent managing the nodes
        + Python: Built on top of Python, which is very easy to learn and write scripts. It is one of the robust programming languages.
        + SSH: Passwordless network authentication makes it more secure and easy to set up
        + Push architecture: The core concept is to push multiple small codes to configure and run the action on client nodes.
        + Set up: This is very easy to set up with a very low learning curve. It is open-source; so, anyone can access it.
        + Manage inventory: Machines’ addresses are stored in a simple text format and we can add different sources of truth to pull the list using plug-ins such as OpenStack, Rackspace, etc.
    - What are the advantages of Ansible?
        + It is agentless and only requires SSH service running on target machines.
        + Python is the only required dependency and, fortunately, most systems come with it pre-installed.
        + It requires minimal resources; so, there is low overhead.
        + It is easy to learn and understand since Ansible tasks are written in YAML.
        + Unlike other tools, most of which are procedural, Ansible is declarative; it defines the desired state and fulfills the requirements needed to achieve it.
    - What is Ansible Galaxy?
        + Ansible Galaxy is a repository for Ansible roles. Ansible Galaxy for Ansible is what PyPI is for Python, or what Maven is for Java.
    - What are Ansible tasks?
        + The task is a unit action of Ansible. It helps by breaking a configuration policy into smaller files or blocks of code. These blocks can be used in automating a process.
    - What is a playbook?
        + A playbook has a series of YAML-based files that send commands to remote computers via scripts. Developers can configure complete complex environments by passing a script to the required systems rather than using individual commands to configure computers from the command line remotely. Playbooks are one of Ansible’s strongest selling points and are often referred to as Ansible’s building blocks.
    - Where are tags used?
        + A tag is an attribute that sets the Ansible structure, plays, tasks, and roles. When an extensive playbook is needed, it is more useful to run just a part of it as opposed to the entire thing. That is where tags are used.
    -  What are ad hoc commands? Give an example:
        + Ad hoc commands are simple one-line commands used to perform a certain task. You can think of ad hoc commands as an alternative to writing playbooks. An example of an ad hoc command is as follows:
            * `ansible host -m netscaler -a "nsc_host=nsc.example.com user=apiuser password=apipass"`
    - What is an Ansible vault?
        + Ansible vault is used to keep sensitive data, such as passwords, instead of placing it as plain text in playbooks or roles. Any structured data file or single value inside a YAML file can be encrypted by Ansible.
        + To encryt data: `ansible-vault encrypt foo.yml bar.yml baz.yml`
        + To decrypt data: `ansible-vault decrypt foo.yml bar.yml baz.yml`

- **Advance questions**:
    - Which protocol does Ansible use to communicate with Linux and Windows?
        + For Linux, the protocol used is SSH.
        + For Windows, the protocol used is WinRM.
    - What is Ansible-doc?
        + Ansible-doc displays information on modules installed in Ansible libraries. It displays a listing of plug-ins and their short descriptions, provides a printout of their documentation strings, and creates a short snippet that can be pasted in a playbook.
    - What is the method to check the inventory vars defined for the host?
        + `ansible -m debug -a "var=hostvars['hostname']" localhost`
    - Explain Ansible facts:
        + Ansible facts can be thought of as a way for Ansible to get information about a host and store it in variables for easy access. This information stored in predefined variables is available to use in the playbook. To generate facts, Ansible runs the set-up module.
    - How to create an empty file with Ansible?
        + To create an empty file you need to follow the steps given below:
            * Step 1: Save an empty file into the files directory
            * Step 2: Copy it to the remote host
    - Explain Ansible modules in detail:
        + Ansible modules are small pieces of code that perform a specific task. Modules can be used to automate a wide range of tasks. Ansible modules are like functions or standalone scripts that run specific tasks idempotently. Their return value is JSON strings in stdout and its input depends on the type of module.<br>There are two types of modules:
            * Core modules: These are modules that the core Ansible team maintains and will always ship with Ansible itself. The issues reported are fixed on priority than those in the extras repo. The source of these modules is hosted by Ansible on GitHub in Ansible-modules-core.
            * Extras Modules: The Ansible community maintains these modules; so, for now, these are being shipped with Ansible but they might get discontinued in the future. Popular extras modules may be promoted to core modules over time. The source for these modules is hosted by Ansible on GitHub in Ansible-modules-extras.
    - What is Ansible inventory and its types?
        + An Ansible inventory file is used to define hosts and groups of hosts upon which the tasks, commands, and modules in a playbook will operate.<br>In Ansible, there are two types of inventory files, static and dynamic:
            * Static inventory: Static inventory file is a list of managed hosts declared under a host group using either hostnames or IP addresses in a plain text file. The managed host entries are listed below the group name in each line.
            * Dynamic inventory: Dynamic inventory is generated by a script written in Python or any other programming language or, preferably, by using plug-ins. In a cloud set-up, static inventory file configuration will fail since IP addresses change once a virtual server is stopped and started again.
    - What are the registered variables under Ansible?
        + Registered variables are valid on the host for the remainder of the playbook run, which is the same as the lifetime of facts in Ansible. Effectively registered variables are very similar to facts. While using register with a loop, the data structure placed in the variable during the loop will contain a results attribute, which is a list of all responses from the module.
    - How do you test Ansible projects?
        + Asserts: Asserts duplicates how the test runs in other languages like Python. It verifies that your system has reached the actual intended state, and not just as a simulation that you would find in check mode. Asserts shows that the task did the job it was supposed to do and changed the appropriate resources.
        + Check mode: Check mode shows you how everything would run without the simulation. Therefore, you can easily see if the project behaves the way we expected it to. The limitation is that check mode does not run the scripts and commands used in the roles and playbooks. To get around this, we have to disable check mode for specific tasks by running.
        + Command: `check_mode: no`
        + Manual run: Just run the play and verify that the system is in its desired state. This testing choice is the easiest method, but it carries an increased risk because it results in a test environment that may not be similar to the production environment.