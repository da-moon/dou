## Default ECS Docker Service Configuration

This should be sufficient for 90% of docker app server deployments. This configuration will build an ECS service for your container
and will route traffic to the following internal DNS name SERVICE_NAME.api.ENV.corvesta.net where SERVICE_NAME is value of the
"service_name" parameter configured in your locals.tf and ENV is dev/qa/uat/prod based on the environment.

#### Important ####

All services using the "default_service" should be scaled with some version of autoscaling. Currently only cpu and memory
based autoscaling can be configured. I recommend CPU autoscaling for almost all configurations unless there are special
requirements for your service. You will not be able to scale your service through Terraform Enterprise manually anymore.

---


This service will configure logging and ship all log messages sent to your docker container's STDOUT/STDERR to logstash
and will tag those messages with service_name. To see your log messages, visit kibana and search for tag:"service_name"

I.E. Search kibana.dev.corvestacloud.com for:    tag:"hello-world"

---

This service exports the following environment variables to your docker container for consumption configuration of application
logging / initialization:

* **DOGSTATSD_PORT_8125_UDP_ADDR** - The IP address to send messages to the datadog agent over
* **CONSUL_HOST** - Path & Port of consul: I.E: http://consul.{env}.corvestacloud.com:8500
* **LOGSTASH_ADDRESS** - The address of logstash you may use to for centralized logging configuration
* **LOGSTASH_TCP_PORT** - TCP port to send logs to logstash for JSON TCP logstash logging
* **LOGSTASH_UDP_PORT** - UDP port to send logs to logstash for JSON UDP logstash logging
* **LOGSTASH_GELF_UDP_PORT** - UDP Port to send logs to for GELF formatted logstash logs
