# README

This is a airflow repo for creating DAG's

## Call DAG run with API

[https://airflow.apache.org/api.html](https://airflow.apache.org/api.html)

### Payload for DAG's

Example Request for hello world:

```json
{"conf":
    {
        "message":"hello world!"
    }
}
```

## Running Locally

First, build the Docker container:

```
docker image build --no-cache --ssh gitlab_ssh_key=~/.ssh/your_gitlab_ssh_key_file . -t fewknow-airflow:0.1.0
```

Where `your_gitlab_ssh_key_file` contains the SSH key you use for DigitalOnUs repositories. This is likely `~/.ssh/id_rsa` or `~/.ssh/ed25519`. Note: you will need Docker 18.09+ to run this, and the `-ssh` flag does NOT transfer key data anywhere; instead, this flag simply notifies the Docker builder to use SSH, and the client (your computer) signs the connection request remotely. The key itself never leaves the client, nor does the Docker builder retain any information that could be used to re-SSH into Gitlab.

**IMPORTANT:** you must rebuild the Docker image anytime an operator gets added to the operators repo, otherwise the changes will not be reflected in the DAG. Also, **anytime you want to add a module to be pip installed, you must add it as a separate RUN command in the Dockerfile.** For whatever reason, creating a requirements.txt and running `pip install -r requirements.txt` does not seem to work (the Docker container simply doesn't update with the installed packages).

The DAG's code exists in the /dag folder. Once you have your code ready you can run the command `docker-compose up`. This will start airflow and try to create your DAG. You can access airflow at `localhost:8080`.

You will want to make sure you keep inline with the correct version of the fewknow airflow container. You can find versions [Here](http://confluence.fewknow.com/display/DO/Devops+Release+Notes). You can update this in the `docker-compose.yml` file at `038131160342.dkr.ecr.us-east-1.amazonaws.com/airflow:0.0.5`
