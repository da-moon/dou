#!/bin/bash

cat <<EOF >> /opt/filebeat.yml
################### Filebeat Configuration Example #########################

############################# Filebeat ######################################
filebeat:
  # List of prospectors to fetch data.
  prospectors:
    # Each - is a prospector. Below are the prospector specific configurations
    -
      paths:
        - /var/log/messages
      input_type: log
      document_type: syslog
    -
      paths:
        - /var/log/audit/audit.log
      input_type: log
      document_type: audit

  # Name of the registry file. Per default it is put in the current working
  # directory. In case the working directory is changed after when running
  # filebeat again, indexing starts from the beginning again.
  registry_file: /var/lib/filebeat/registry


###############################################################################
############################# Libbeat Config ##################################
# Base config file used by all other beats for using libbeat features

############################# Output ##########################################

# Configure what outputs to use when sending the data collected by the beat.
# Multiple outputs may be used.
output:


  ### Logstash as output
  logstash:
    # The Logstash hosts
    hosts: [""]
    bulk_max_size: 1024

    # Optional TLS. By default is off.
    tls:
      # List of root certificates for HTTPS server verifications
      #certificate_authorities: ["/etc/pki/tls/certs/logstash-forwarder.crt"]


############################# Logging #########################################

# There are three options for the log ouput: syslog, file, stderr.
# Under Windos systems, the log files are per default sent to the file output,
# under all other system per default to syslog.
logging:

  # Send all logging output to syslog. On Windows default is false, otherwise
  # default is true.
  #to_syslog: true

  # Write all logging output to files. Beats automatically rotate files if rotateeverybytes
  # limit is reached.
  #to_files: false

  # To enable logging to files, to_files option has to be set to true
  files:
    # The directory where the log files will written to.
    #path: /var/log/mybeat

    # Configure log file size limit. If limit is reached, log file will be
    # automatically rotated
    rotateeverybytes: 10485760 # = 10MB
EOF

docker run -d --name filebeat --restart always \
-v /opt/filebeat.yml/:/filebeat.yml \
-v /var/log/:/var/log/:ro \
-d prima/filebeat /bin/filebeat
