job "enterprise_scheduler" {
    type = "batch"
    datacenters = ["aws-us-east-1"]
    parameterized {
        payload = "forbidden"
        meta_required = ["ENDPOINT","TENANT","TIMESTAMP","JOB_TYPE","JOB_NAME"]
    }

	reschedule {
      attempts  = 0
      unlimited = false
    }

    group "ids" {
        task "id" {
            driver = "docker"
    		resources {
        		memory = 1000
        	}
            template {
              data = <<EOH
                    CONTAINER_TAG="{{key "nomad/jobs/enterprise_scheduler/nomad-enterprise-scheduler"}}"
                    LOGGING="{{key "nomad/logging"}}"
              EOH
               destination = "secrets/rendered.env"
               env = true
               change_mode = "noop"
            }
            config {
                image = "038131160342.dkr.ecr.us-east-1.amazonaws.com/nomad-enterprise-scheduler:${CONTAINER_TAG}"
                logging {
                  type = "gelf"
                  config {
                    gelf-address = "udp://${LOGGING}"
                    tag = "nomad-enterprise-scheduler"
                  }
                }
            }

        }
    }
}
