# Docker Lab 🐳

# 1. Basics

Pull [Nginx](https://www.nginx.com) Image from Docker Repository
> What is [Nginx](https://www.nginx.com/resources/glossary/nginx/) ?
>
>  NGINX is open source software for web serving, reverse proxying, caching, load balancing, media streaming,
>  and more. ... In addition to its HTTP server capabilities, NGINX can also function as a proxy server for
>  email (IMAP, POP3, and SMTP) and a reverse proxy and load balancer for HTTP, TCP, and UDP servers

### Instructions

> PreRequisites
>
> Docker 19.X Installed or Docker id created and use the [DockerOnLine](https://labs.play-with-docker.com/) application
>

1. List the existing docker images in your docker host.

    ```
    docker images
    ```

2. Pull the ***latest*** version of [Nginx](https://www.nginx.com/resources/glossary/nginx/) image.
   ```
    docker pull nginx:latest
    ```
3. Pull the ***1.16*** version of [Nginx](https://www.nginx.com/resources/glossary/nginx/) image.
   ```
    docker pull nginx:1.16
    ```
4.  List the existing docker images in your docker host and observe that you have the latest and 1.16  version of Nginx
downloaded to your docker host

    ```
    docker images
    ```


You should be able to list your local images and the latest version of Nginx image should be displayed

```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nginx               1.16                960143eb8965        3 days ago          127MB
nginx               latest              5ad3bd0e67a9        3 days ago          127MB
```

- Draw by your self a representation of the docker Architecture
- Explain the importance of Docker Hub into the Docker Architecture
- Provide an alternative solution to the use of Docker Hub
- Compare and analyze Docker Hub VS your alternative solution and identify the pros and cons
- Mention the docker commands involved to Docker Hub

# 2. Dockerfile

Create and run a basic python container and run a test python script.

### Instructions
Create a custom docker image using Dockerfile and manually install nodejs and any remaining dependency to run the following project https://github.com/geerlingguy/demo-nodejs-api

You can test if this app is running by browsing to the `/hello/MY_NAME` resource.

# 3. Docker compose

Use Docker compose to start python Flask app and Nginx at same time.

### Instructions

> PreRequisites
>
> Docker 19.X Installed or Docker id created and use the [DockerOnLine](https://labs.play-with-docker.com/) application
>


1. Create a new file named ***flask-example.py***
    ```
        from flask import Flask

        app = Flask(__name__)

        @app.route("/")
        def hello():
            return "Hello World!"


        if __name__ == "__main__":
            app.run('0.0.0.0')
    ```
2. Create a new file named ***dockerfile***
     ```
    FROM python:3
    WORKDIR /usr/src/app
    RUN pip install Flask
    COPY . .
    CMD [ "python", "./flask-example.py" ]
    ```

3. Create a new file named ***docker-compose.yml***
   ```
    version: '3'
    services:
        flask-example:
            restart: always
            build:
              dockerfile: dockerfile
              context: .
            ports:
              - '81:5000'
        web:
            image: nginx
            ports:
              - '80:80'

    ```

4. Run the below command in order to create/build  and run images:
   ```
    docker-compose up --build -d
    ```

5.  Display Images:

    ```
    docker-compose images
    ```
5.  Display current running containers:

    ```
    docker ps -a
    docker-compose ps
    ```

- What are the benefits to use docker compose ?
- Explain the docker compose file and the commands/directives used in this example.

# 4. DockerHub
Build a Dockerfile to create an image containing azure cli + terraform and upload to docker hub.

### Instructions

Create a new file named Dockerfile

Research and troubleshoot if any issue to accomplish the following:

- Install latests azure cli and its dependencies
- Install terraform  binary
- Build the Dockerfile to create an image


Create an account at [docker hub](https://hub.docker.com)
Create a repository in your account
At your terminal login to docker hub
Tag the image and upload the image to your repo


