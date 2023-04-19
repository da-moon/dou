//
// Pipeline code to validate/terratest/tagging/publishing terraform code
//
def call() {
    pipeline {
        agent any
        environment {
            AWS_DEFAULT_REGION="us-east-2"
        }
        parameters {
            choice(choices: ['False', 'True'], description: 'Skipping `terraform validate` stage', name: 'SKIP_TF_VALIDATE')
            string(defaultValue: "terraform-cldsvc-prod.corp.internal.citizensbank.com", description: 'Terraform Enterprise hostname', name: 'TFE_HOST')
            string(defaultValue: "cfg-cloud-services", description: 'Terraform Enterprise organization', name: 'TFE_ORG')
            string(defaultValue: "120", description: 'Terratest timeout in minutes', name: 'TERRATEST_TIMEOUT')
            string(defaultValue: "prod", description: 'Indicates the environment where the infrastructure will be deployed, and the config files should take (by example the prod.tfvars file)', name: 'ENV_NAME')
        }
        stages {
            stage("Set up env"){
                steps{
                    script{
                        env.GIT_AUTHOR = sh(script: "eval git log -1 --pretty=format:'%an'", returnStdout: true).trim()
                        env.REPO_NAME = env.GIT_URL.replaceFirst(/^.*\/([^\/]+?).git$/, '$1')
                        if (!env.BRANCH_NAME){
                            env.BRANCH_NAME = "${GIT_BRANCH.split("origin/")[1]}"
                        }
                        env.BRANCH_WS = env.BRANCH_NAME.replaceAll('/', '-')
                        env.TFE_WORKSPACE = sh(script: "eval echo 'terratest-$REPO_NAME-$BUILD_ID-$BRANCH_WS'", returnStdout: true).trim()
                    }

                    common()
                }
            }
            stage("Terraform Validate"){
                when{ expression {env.SKIP_TF_VALIDATE == 'False'} }
                steps{
                    tfvalidate()
                }
            }
            stage("Terratest"){
                steps{
                    terratest()
                }
            }
            stage("Create tag"){
                when{ expression {env.GIT_AUTHOR != 'Jenkins CI' && env.BRANCH_NAME == 'master'} }
                steps{
                    autotagPublish()
                }
            }
        }
        post {
            always {
                echo "Cleaning up Workspace"
                deleteDir() /* clean up our workspace */
            }
        } // post ends
    }
}
