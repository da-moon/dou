## Chef Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

### Cheat Sheet

![Chef Cheat Sheet](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/chef-cheat-sheet.png)

### Questions

- **Basic questions**:
    - What is Chef used for?
        + Chef is a systems and cloud infrastructure automation framework that makes it easy to deploy servers and applications to any physical, virtual, or cloud location, no matter the size of the infrastructure.
    - What is a Chef Server, A Chef Node and Chef Workstation?
        + The Chef server acts as a hub of information. Cookbooks and policy settings are uploaded to the Chef server by users from workstations. 
        + A node is any machine—physical, virtual, cloud, network device, etc.—that is under management by Chef
        + A workstation is configured to allow users to author, test, and maintain cookbooks
    - What is knife used for?
        + Knife is command-line tool to interact with nodes or work with objects on the Chef server.
    - What is a recipe?
        + Most recipes are simple patterns (blocks that define properties and values that map to specific configuration items like packages, files, services, templates, and users).
    - What is a cookbook?
        + A cookbook is the fundamental unit of configuration and policy distribution. A cookbook defines a scenario and contains everything that is required to support that scenario:
            * Recipes that specify the resources to use and the order in which they are to be applied.
            * Attribute values.
            * File distributions.
            * Templates.
            * Extensions to Chef, such as libraries, definitions, and custom resources
    - What is the language you use for customize resources in Chef?
        + Ruby.
    - Which command should be used to create a Chef cookbook within the chef-repo, if the cookbook name is apache?
        + `chef generate cookbook apache` 
    - Why are SSL certificates used in Chef?
        + You need the SSL certificate for the initial configuration of the Chef and for creating the certificate and private keys in Nginx. This ensures that the right data can be accessed between the Chef Client and Chef Server.


- **Advance questions**:
    - What is the process of bootstrapping?
        + Is a common way to install the chef-client on a node.
    - What is a resource in chef?
        + A resource is a statement of configuration policy that:
            * Describes the desired state for a configuration item.
            * Declares the steps needed to bring that item to the desired state.
            * Specifies a resource type—such as package, template, or service.
            * Lists additional details (also known as resource properties), as necessary.
            * Are grouped into recipes, which describe working configurations.
    - What is a run-list in Chef?
        + A run-list defines all of the information necessary for Chef to configure a node into the desired state. A run-list is:
            * An ordered list of roles and/or recipes that are run in the exact order defined in the run-list; if a recipe appears more than once in the run-list, the chef-client will not run it twice.
            * Always specific to the node on which it runs; nodes may have a run-list that is identical to the run-list used by other nodes.
            * Stored as part of the node object on the Chef server.
            * Maintained using knife, and then uploaded from the workstation to the Chef server, or is maintained using the Chef management console.
    - How does a cookbook differ from a recipe in chef?
        + A Recipe is a collection of Resources, and primarily configures a software package or some piece of infrastructure. A Cookbook groups together Recipes and other information in a way that is more manageable than having just Recipes alone.
    - What information do you need in order to bootstrap in chef?
        + Your node’s host name or public IP address.
        + A user name and password you can log on to your node with.
        + Alternatively, you can use key-based authentication instead of providing a user name and password.
    - How do you apply an updated Cookbook to your node in Chef?
        + These are the 3 ways to do it:
            * Run knife ssh from your workstation.
            * SSH directly into your server and run chef-client.
            * You can also run chef-client as a daemon, or service, to check in with the Chef server on a regular interval, say every 15 or 30 minutes.
    - How do make a runlist to be run in a node?
        + run chef-client command in the node.
    - What is the node object made up of?
        + Node attributes, Nodes run_list.
    - Where is the chef-client configuration file located?
        + `/etc/chef/client.rb`
    - What is the importance of Chef starter kit?
        + The starter kit is needed for creating the configuration files in Chef. It gives you the information for interacting with the server and defining the configuration file. You can easily download the starter kit and use it at the desired place on the workstation.
