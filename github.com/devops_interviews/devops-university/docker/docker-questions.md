## Docker Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

- **Basic questions**:
    - What is Docker?
        + Docker is an open source containerization platform.
    - Difference between a Container and a Virtual Machine?
        + Docker is container based technology and containers are just user space of the operating system. A Virtual Machine, on the other hand, is not based on container technology. They are made up of user space plus kernel space of an operating system.
        The idea of containers is something that runs and can be destroy as easy as that, and in a virtual machine you need or want to keep it up across the time (updates, patches, etc).
- **Advance questions**:
    - What is a DockerFile?
        + A text document that contains all the commands a user could call on the command line to assemble an image.
    - What is Docker Compose?
        + A tool that was developed to help define and share multi-container applications. With Compose, you can create a YAML file to define the services and with a single command, can spin everything up or tear it all down.
    - What is a Docker image?
        + A Docker image is an immutable (unchangeable) file that contains the source code, libraries, dependencies, tools, and other files needed for an application to run.
    - What is a Docker container?
        + A Docker container is a virtualized run-time environment where users can isolate applications from the underlying system. In other words Docker Container is the run time instance of images.