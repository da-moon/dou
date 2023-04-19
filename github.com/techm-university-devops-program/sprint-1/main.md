# Main Activity: Python and Dockerfiles 

### In this activity, you will create a Python Dockerfile for your project.

## Instructions 👨‍🏫

Go to your demo-app project repository, and find the ```src```	folder.

Once you find them, you will see a folder of each microservice that compose your demo app, find the ```recommendationservice```, and the ```emailservice``` folders.

Both folders are missing a Dockerfile to build the microservice.

Your job during this activity will be to create the necessary Dockerfiles to be able to complete the construction of the microservice.

To achieve it successfully, follow the instructions below:

## For Email Service	📧

 - Create a file called ```Dockerfile``` inside the directory.

 - Use the following image as base: ```python:3.7-slim as base```
	
 - Use the base as builder

 - run the following command: 
	``` bash
		apt-get -qq update \
		&& apt-get install -y --no-install-recommends \
		g++ \
		&& rm -rf /var/lib/apt/lists/* 
		```

- Copy the ```requirements.txt``` file and install it using the ```pip``` command.

- Use the base as final

- Set the following ENV variables:
	``` bash
		PYTHONUNBUFFERED=1

		ENABLE_PROFILER=1
	```
 - run the following command: 
	``` bash
		apt-get -qq update \
    && apt-get install -y --no-install-recommends \
        wget
	```

 - Download the grpc health probe:

	``` bash
	GRPC_HEALTH_PROBE_VERSION=v0.4.11 && \
    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe
	```

 - Set the following dirrectory as your working directory: ```/email_server```

 - Grab and copy packages from builder to the following directory: ```/usr/local/lib/python3.7/``` then Copy all to the final image.

 - Expose the *8080* port.

 - Use ```"python"``` and ```"email_server.py"```	as entrypoint.

## For Recommendation Service	✅

 - Create a file called ```Dockerfile``` inside of the directory.

 - Use the following image: ```python:3.7-slim``

 - run the following command: 
	``` bash
		apt-get -qq update \
		&& apt-get install -y --no-install-recommends \
		g++ \
		&& rm -rf /var/lib/apt/lists/* 
		```
	
- Set the following ENV variables:
	``` bash
		PYTHONUNBUFFERED=0
	```

 - Download the grpc health probe:

	``` bash
	GRPC_HEALTH_PROBE_VERSION=v0.4.11 && \
    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe
	```

 - Set the following dirrectory as your working directory: ```/recommendationservice```

- Copy the ```requirements.txt``` file and install it using the ```pip``` command, and then copy all the files to the root.

 - Expose and set as ENV variable the *8080* port.

 - Use ```"python"``` and ```""/recommendationservice/recommendation_server.py""```	as entrypoint.


you can find some references about these dockerfiles on the ```docs/examples/Docker``` directory on the demo-app repository.

## Expected deliverables

code and proof of successful stages completion, it can be a screenshot.

