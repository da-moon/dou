//
// Pipeline code to build an AMI in AWS
//


// Share library function to inject a Packer Pipeline into a Jenkinsfile
// you can pass ami_os_type to specify which config to build in the ami_config.json file
// If no config is select we attempt to just grab one. Assuming there will only be one.
def call(ami_os_type = '', ignore_hash = false) {

  AMI_ID = ''
  AWS_MAX_ATTEMPTS = 120
  AWS_POLL_DELAY_SECONDS = 60

  pipeline {
    agent {
      node {
        label ""
      }
    }
    environment {
      //NEXUS_URL             = "https://nexus-aws-prod.corp.internal.citizensbank.com/repository/maven-internal/com/example/myproject/0.0.1-SNAPSHOT/myproject-0.0.1-SNAPSHOT.jar"
      NEXUS_URL             = "https://nexus-aws-prod.corp.internal.citizensbank.com/repository/maven-internal/com/citizensbank/clddo/ami-aws-scaffolding-build/ami-devsecops-cloud-poc-0.0.1-SNAPSHOT/0.0.1-SNAPSHOT-30aea6db-69e0-4038-b67f-d49b28b832dc/ami-devsecops-cloud-poc-0.0.1-SNAPSHOT-0.0.1-SNAPSHOT-30aea6db-69e0-4038-b67f-d49b28b832dc.jar"
      //NEXUS_URL             = "${env.Nexus_Url_Artifact}"
      API_PASSWORD          = credentials('snow_api_query')
      AMI_OS_TYPE           = "${ami_os_type}"
      IGNORE_HASH           = "${ignore_hash}"
    }
    stages {

      stage('Hash Tagging Strategy') {
        steps {

          sh '''#!/bin/bash
            set -e
            AWSCLI="/usr/local/bin/aws"
            JQ="/bin/jq"

            # If ami_os_type was passed as a parameter then just grab the first one in the config
            if [ -z "$AMI_OS_TYPE" ]; then
              export AMI_OS_TYPE=`$JQ -r ".[0].os_type" ami_config.json`
            fi

            echo "AMI_OS_TYPE = \\"$AMI_OS_TYPE\\""
            export AWS_ACCOUNT_ID=`$JQ -r ".[]| select(.os_type == \\"$AMI_OS_TYPE\\" ).owner" ami_config.json`
            export AWS_AMI_NAME=`$JQ -r ".[]| select(.os_type == \\"$AMI_OS_TYPE\\" ).Name" ami_config.json`
            rm -rf .git .gitignore .editorconfig
            rm -rf ${WORKSPACE}/codeHash.txt
            find . -type f \\( -exec sha1sum "$PWD"/{} \\; \\) | awk '{print $1}' | sort | sha1sum | awk '{print $1}' > ${WORKSPACE}/codeHash.txt
            codeHash=$(eval cat ${WORKSPACE}/codeHash.txt)
            echo "This is hash from code-repo $codeHash"

            $AWSCLI sts assume-role --role-arn "arn:aws:iam::$AWS_ACCOUNT_ID:role/cfg-packer-shared" --role-session-name "Packer" --duration-seconds 14400 > ${WORKSPACE}/tmpfile
            [[ "$?" != "0" ]] && error 4 "FAILED: Unable to assume the requested role!!" exit

            export AWS_ACCESS_KEY_ID=$($JQ -r '.Credentials.AccessKeyId' ${WORKSPACE}/tmpfile)
            [[ "$?" != "0" ]] && error 5 "FAILED: Unable to set AWS Access Key ID!!" exit

            export AWS_SECRET_ACCESS_KEY=$($JQ -r '.Credentials.SecretAccessKey' ${WORKSPACE}/tmpfile)
            [[ "$?" != "0" ]] && error 6 "FAILED: Unable to set AWS Secret Access Key!!" exit

            export AWS_SESSION_TOKEN=$($JQ -r '.Credentials.SessionToken' ${WORKSPACE}/tmpfile)
            [[ "$?" != "0" ]] && error 7 "FAILED: Unable to set AWS Session Token!!" exit

            if [ -z "$codeHash" ] || [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
              echo "Invalid parameters.  Usage:"
              exit 1
            fi
            if [[ ${IGNORE_HASH} == "false" ]]; then
              echo "Validating AMI hash"
              for taghash in $($AWSCLI ec2 describe-tags --filters Name=key,Values=Code-Hash Name=resource-type,Values=image --query 'Tags[*].Value' --output text); do
                codeHash=$(eval cat ${WORKSPACE}/codeHash.txt)
                if [[ "$codeHash" == "$taghash" ]]; then
                  rm -rf ${WORKSPACE}/tmpfile ${WORKSPACE}/codeHash.txt
                  echo "The AMI is already exist"
                  exit 1
                fi
              done
            else
              echo "Ignoring AMI hash"
            fi
          '''
        }
      }

      stage( "Copy Library Files"){
        steps{
          script {

            def libver = env."library.cloud-aws-jenkins-library.version"
            echo "Library Version=$libver"

            dir("sharedlib")
            {
              checkout([$class: 'GitSCM',
                branches: [[name: libver]],
                userRemoteConfigs: [[
                  credentialsId: 'cldsv-jenkins-bb',
                  url: 'ssh://git@internal-bitbucket-p-app-clb-621196423.us-east-1.elb.amazonaws.com/clddo/cloud-aws-jenkins-library.git'
                ]]
              ])
            }

            // Copy packer scripts to packer dir
            sh "cp -R sharedlib/resources/com/citizensbank/scripts/packer ./"
          }
        }
      }

      stage("Install Requirements"){
        steps{
          dir('ansible'){
            sh "sudo -E ansible-galaxy install -r requirements.yml -p ./playbooks/roles/"
            sh "sudo -E chown -R jenkins:jenkins ./playbooks/roles/"
          }
        }
      }

      stage("Building AMI"){
        steps{
          sh '''#!/bin/bash
            set -e
            JQ="/bin/jq"

            # If ami_os_type was passed as a parameter then just grab the first one in the config
            if [ -z "$AMI_OS_TYPE" ]; then
              export AMI_OS_TYPE=`$JQ -r ".[0].os_type" ami_config.json`
            fi

            export SYSID_APP=`$JQ -r ".[]| select(.os_type == \\"$AMI_OS_TYPE\\" ).ApplicationID" ami_config.json`
            export AMI_ACCOUNT=`$JQ -r ".[]| select(.os_type == \\"$AMI_OS_TYPE\\" ).AMI_Account_Name" ami_config.json`
            export LIBRARY_TAGS_VERSION=`$JQ -r ".[]| select(.os_type == \\"$AMI_OS_TYPE\\" ).library_template_version" ami_config.json`
            cd packer
            export PASS_ENCRYPT=$(echo -n "cmdb.integration:$API_PASSWORD" | base64)
            curl "https://wwwservicenow.production.citizensbank.myshn.net/api/icfg/servicenowbusinessappdata/get_business_app_data/$SYSID_APP" --request GET --header "Accept:application/json" --header "Authorization:basic $PASS_ENCRYPT" | jq ".result" > tags.auto.pkrvars.json
            cat tags.auto.pkrvars.json
            echo Building AMI.

            echo "AMI_OS_TYPE is $AMI_OS_TYPE"
            sudo -E ./buildAMI.bsh
          '''
        }
      }

      stage("Remove Old AMI"){
        steps{
          sh '''#!/bin/bash
            set -e
            AWSCLI="/usr/local/bin/aws"
            JQ="/bin/jq"

            # If ami_os_type was passed as a parameter then just grab the first one in the config
            if [ -z "$AMI_OS_TYPE" ]; then
              export AMI_OS_TYPE=`$JQ -r ".[0].os_type" ami_config.json`
            fi

            export SYSID_APP=`$JQ -r ".[]| select(.os_type == \\"$AMI_OS_TYPE\\" ).ApplicationID" ami_config.json`
            export AWS_ACCOUNT_ID=`$JQ -r ".[]| select(.os_type == \\"$AMI_OS_TYPE\\" ).owner" ami_config.json`
            export AMI_TAG_NAME=`$JQ -r ".[]| select(.os_type == \\"$AMI_OS_TYPE\\" ).Name" ami_config.json`
            AMI_TAG=${AMI_TAG_NAME}
            $AWSCLI sts assume-role --role-arn "arn:aws:iam::$AWS_ACCOUNT_ID:role/cfg-packer-shared" --role-session-name "Packer" --duration-seconds 14400 > ${WORKSPACE}/tmpfile
            [[ "$?" != "0" ]] && error 4 "FAILED: Unable to assume the requested role!!" exit

            export AWS_ACCESS_KEY_ID=$($JQ -r '.Credentials.AccessKeyId' ${WORKSPACE}/tmpfile)
            [[ "$?" != "0" ]] && error 5 "FAILED: Unable to set AWS Access Key ID!!" exit

            export AWS_SECRET_ACCESS_KEY=$($JQ -r '.Credentials.SecretAccessKey' ${WORKSPACE}/tmpfile)
            [[ "$?" != "0" ]] && error 6 "FAILED: Unable to set AWS Secret Access Key!!" exit

            export AWS_SESSION_TOKEN=$($JQ -r '.Credentials.SessionToken' ${WORKSPACE}/tmpfile)
            [[ "$?" != "0" ]] && error 7 "FAILED: Unable to set AWS Session Token!!" exit

            while IFS='' read -r line; do ami_sorted+=("$line"); done < <($AWSCLI ec2 describe-images --owner self --filters "Name=tag:Name,Values=$AMI_TAG" "Name=tag:ApplicationID,Values=$SYSID_APP" --region us-east-1 --query 'Images[*].[ImageId,CreationDate]' --output text | sort -k2 -r | cut -f1)
            echo "${ami_sorted[@]}"

            for i in {0..4}
            do
              echo "${ami_sorted[$i]}"
              unset ami_sorted["$i"]
            done

            for AMI in "${ami_sorted[@]}"
            do
              echo "$AMI"
              while IFS='' read -r line; do snapshot_array+=("$line"); done < <($AWSCLI ec2 describe-images --image-ids "$AMI" --region us-east-1 --output text --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId' | sort -k2 -r | cut -f1)

              echo "Deregistering AMI: $AMI"
              $AWSCLI ec2 deregister-image --image-id "$AMI"

              echo "Removing Snapshot"

              for snapshot in "${snapshot_array[@]}"
              do
                echo "Deleting Snapshot: $snapshot"
                $AWSCLI ec2 delete-snapshot --snapshot-id "$snapshot"
              done
              unset snapshot_array
            done
          '''
        }
      }

    } // stages
    post {
        always {
          echo "Cleaning up Workspace"
          deleteDir() // clean up our workspace
        }
    } // post
  } // pipeline
} // call()
