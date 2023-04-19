import groovy.transform.SourceURI
import java.nio.file.Path
import java.nio.file.Paths

class ScriptSourceUri {
  @SourceURI
  static URI uri
}

@com.cloudbees.groovy.cps.NonCPS
def getLibPath() {
  Path scriptLocation = Paths.get(ScriptSourceUri.uri)
  return scriptLocation.getParent().getParent().resolve('resources').toString()
}

// Share library function to inject a Packer Pipeline into a Jenkinsfile
// you can pass ami_os_type to specify which config to build in the ami_config.json file
// If no config is select we attempt to just grab one. Assuming there will only be one.
def call(stageParams) {

  AMI_ID = ''
  AWS_MAX_ATTEMPTS = 120
  AWS_POLL_DELAY_SECONDS = 60

  pipeline {
    agent {
      label "agent-small"
    }
    environment {
      //NEXUS_URL             = "https://nexus-aws-prod.corp.internal.companyA.com/repository/maven-internal/com/example/myproject/0.0.1-SNAPSHOT/myproject-0.0.1-SNAPSHOT.jar"
      //API_PASSWORD          = credentials('snow_api_query')
      API_PASSWORD          = "Business!234"
      AMI_OS_TYPE           = "${ami_os_type}"
    }
    stages {
        stage("Prepare"){
            steps {
              script {
                  prepareBuild()
              }
            }
        }
        stage("Register"){
            steps {
                script {
                    registerBuild()
                }
            }
        }
        stage("Build") {
            steps {
                script {
                    buildProject stack: "java"
                }
            }
        }
        stage("Quality"){
            steps {
                script {
                    codeQualityScan stack: "java"
                }
            }
        }
        stage("Package"){
            steps {
                script {
                    try {
                packageStart()
                packageZip dir: "workspace", project: "project-scan"
                packageZip dir: "workspace"
                packageEnd()
                    } catch (e) {
                        processError stage: "Package", error: e.toString()
                        error('Failed to build Upload Package')
                    }
                }

            }
        }
        // stage("Vulnerability"){
        //     steps {
        //         script {
        //             codeSecurityScan stack: "java"
        //         }
        //     }
        // }
        stage("Upload") {
            steps {
                script {
                       uploadBuild(
                        stack: "java",
                        creds: "aws-entsvc-p-2",
                        region: "us-east-1",
                        account: "749622116802",
                        bucket: "${env.BUCKET}"
                    )
                    getArtifactUrl(repository:"maven-internal",version:env.pomVersion,group:env.MVN_GROUPID)
                }
            }
        }
        stage('Hash Tagging Strategy') {
            steps {

              sh '''#!/bin/bash
                set -e
                AWSCLI="/usr/local/bin/aws"
                JQ="/bin/jq"
                export AMI_OS_TYPE=`$JQ -r ".[0].os_type" ami_config.json`
                echo $Nexus_Url_Artifact
                echo "AMI_OS_TYPE = \\"$AMI_OS_TYPE\\""
                export AWS_ACCOUNT_ID=`$JQ -r ".[]| select(.os_type == \\"$AMI_OS_TYPE\\" ).owner" ami_config.json`
                echo $AWS_ACCOUNT_ID
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
               
                export AWS_DEFAULT_REGION=`$JQ -r ".[]| select(.os_type == \\"$AMI_OS_TYPE\\" ).AWS_region" ami_config.json`

                if [ -z "$codeHash" ] || [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
                  echo "Invalid parameters.  Usage:"
                  exit 1
                fi
                for taghash in $($AWSCLI ec2 describe-tags --filters Name=key,Values=Code-Hash Name=resource-type,Values=image --query 'Tags[*].Value' --output text); do
                  codeHash=$(eval cat ${WORKSPACE}/codeHash.txt)
                  if [[ "$codeHash" == "$taghash" ]]; then
                    rm -rf ${WORKSPACE}/tmpfile ${WORKSPACE}/codeHash.txt
                    echo "The AMI is already exist"
                    exit 1
                  fi
                done
              '''
            }
        }
      stage( "Copy Library Files"){
        steps{
          script {

            //def libver = env."library.cloud-aws-jenkins-library.version"
            def libver = "feature/EP-11241-iidk-devsecops-create-devsecops-pipeline-for-springboot-use-with-iidk"
            echo "Library Version=$libver"

            dir("sharedlib")
            {
              checkout([$class: 'GitSCM',
                branches: [[name: libver]],
                userRemoteConfigs: [[
                  credentialsId: 'cloud-services-bitbucket',
                  url: 'https://bitbucket.corp.internal.companyA.com/scm/hoov/hoover-shared-jenkins-libraries.git'
                ]]
              ])
            }

            // Copy packer scripts to packer dir
            sh "cp -R sharedlib/resources/com/companyA/scripts/packer ./"
          }
        }
      }
     // stage("Install Requirements"){
     //   steps{
      //    dir('ansible'){
      //      sh "ls -al"
      //      sh "sudo -E ansible-galaxy install -r requirements.yml -p ./playbooks/roles/"
      //      sh "sudo -E chown -R jenkins:jenkins ./playbooks/roles/"
      //    }
     //   }
     // }
      stage("Building AMI"){
        steps{
          sh '''#!/bin/bash
            set -e
            JQ="/bin/jq"
            export AMI_OS_TYPE=`$JQ -r ".[0].os_type" ami_config.json`

            export SYSID_APP=`$JQ -r ".[]| select(.os_type == \\"$AMI_OS_TYPE\\" ).ApplicationID" ami_config.json`
            export AMI_ACCOUNT=`$JQ -r ".[]| select(.os_type == \\"$AMI_OS_TYPE\\" ).AMI_Account_Name" ami_config.json`
            export LIBRARY_TAGS_VERSION=`$JQ -r ".[]| select(.os_type == \\"$AMI_OS_TYPE\\" ).library_template_version" ami_config.json`
            cd sharedlib/resources/com/companyA/scripts/packer
            export PASS_ENCRYPT=$(echo -n "cmdb.integration:$API_PASSWORD" | base64)
            curl "https://wwwservicenow.production.companyA.myshn.net/api/icfg/servicenowbusinessappdata/get_business_app_data/$SYSID_APP" --request GET --header "Accept:application/json" --header "Authorization:basic $PASS_ENCRYPT" | jq ".result" > tags.auto.pkrvars.json
            cat tags.auto.pkrvars.json
            git tag
            #git fetch --all --tags
            git checkout tags/$LIBRARY_TAGS_VERSION -b sharedlibrary
            cp ../../../../../../ami_config.json .
            cp -avp ../../../../../../ansible ../
            ls -al
            ls -al /opt/
            dzdo packer --version
            echo Building AMI.
            uname -a
            pwd
            #dzdo ls
            dzdo --help
            #AMI_ACCOUNT=${AMI_ACCOUNT} dzdo ./buildAMI.bsh
            dsoprod -E ./buildAMI.bsh
            #sudo -E ./buildAMI.bsh
           
          '''
        }
      }
      stage("Remove Old AMI"){
        steps{
          sh '''#!/bin/bash
            set -e
            AWSCLI="/usr/local/bin/aws"
            JQ="/bin/jq"
            export AMI_OS_TYPE=`$JQ -r ".[0].os_type" ami_config.json`

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
           
            export AWS_DEFAULT_REGION=`$JQ -r ".[]| select(.os_type == \\"$AMI_OS_TYPE\\" ).AWS_region" ami_config.json`

            while IFS='' read -r line; do ami_sorted+=("$line"); done < <($AWSCLI ec2 describe-images --owner self --filters "Name=tag:Name,Values=$AMI_TAG" "Name=tag:ApplicationID,Values=$SYSID_APP" --region $AWS_DEFAULT_REGION --query 'Images[*].[ImageId,CreationDate]' --output text | sort -k2 -r | cut -f1)
            echo "${ami_sorted[@]}"

            for i in {0..4}
            do
              echo "${ami_sorted[$i]}"
              unset ami_sorted["$i"]
            done

            for AMI in "${ami_sorted[@]}"
            do
              echo "$AMI"
              while IFS='' read -r line; do snapshot_array+=("$line"); done < <($AWSCLI ec2 describe-images --image-ids "$AMI" --region $AWS_DEFAULT_REGION --output text --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId' | sort -k2 -r | cut -f1)

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
       

    }
    // post {
    //     always {
    //       echo "Cleaning up Workspace"
    //       deleteDir() // clean up our workspace
    //     }
    // } // post
  } // pipeline
} // call()
