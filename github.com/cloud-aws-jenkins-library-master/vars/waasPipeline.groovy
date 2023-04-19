def call() {

    pipeline {
        agent any
        environment {
            AWS_DEFAULT_REGION="us-east-1"
        }
        parameters {
            string(defaultValue: "", description: 'Optional to Target specific resources', name: 'TF_TARGET')
        }
        stages {
            stage("Set up env"){
                steps{
                    common()
                }
            }
            stage("Analyze Workload config"){
               steps{
                   exportWorkload()
               }
            }
            stage("Downloading pattern") {
                steps {
                    userData()

                    waasRepo()

                    tfFiles()
                }
            }
            stage("Terraform Plan"){
                steps{
                    terraformPlan()
                }
            }
            stage("Terraform Apply"){
                when { expression { env.TF_APPLY == 'Yes' && env.TERRAFORM_DESTROY == 'FALSE' } }
                steps{
                    terraformApply()
                }
            }
            stage("Terraform Destroy"){
                when { expression { env.TERRAFORM_DESTROY == 'TRUE' } }
                steps{
                   terraformDestroy()
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