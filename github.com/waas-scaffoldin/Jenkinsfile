"waasPipeline.groovy"
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
"common.groovy"
def call(){
    def SHAREDLIBRARY_BRANCH = env."library.cloud-aws-jenkins-library.version"
   
    sh """
        echo "Cloning shared library on ${SHAREDLIBRARY_BRANCH}"
    """

    dir("sharedlib"){
        git branch: "${SHAREDLIBRARY_BRANCH}",
            credentialsId: 'bitbucket-devops',
            url: 'ssh://git@internal-bitbucket-p-app-clb-621196423.us-east-1.elb.amazonaws.com/clddo/cloud-aws-jenkins-library.git',
            changelog: false,
            poll: false
    }
    sh '''
        echo "##[debug]Find the terraform folder..."
        folder=`find . -type d -name "terraform"`
        cp -r $folder scripts
    '''
}
"exportWorkload"
def call(){
    sh '''
       echo "####[debug] Export Workload.config vars"
       chmod +x scripts/export-workload-config.sh
    '''
    script{
        env.SUPPORTED_PRODUCT_WORKLOAD = sh(script: "exec echo `./scripts/export-workload-config.sh SUPPORTED_PRODUCT_WORKLOAD`", returnStdout: true).trim()
        env.SUPPORTED_PRODUCT_WORKLOAD_VERSION = sh(script: "eval echo  `./scripts/export-workload-config.sh SUPPORTED_PRODUCT_WORKLOAD_VERSION`", returnStdout: true).trim()
        env.TERRAFORM_DESTROY = sh(script: "eval echo `./scripts/export-workload-config.sh TERRAFORM_DESTROY`", returnStdout: true).trim().toUpperCase()
        env.APP_NAME = sh(script: "eval echo `./scripts/export-workload-config.sh APP_NAME`", returnStdout: true).trim()
        env.LANDING_ZONE = sh(script: "eval echo `./scripts/export-workload-config.sh LANDING_ZONE`", returnStdout: true).trim()
        env.USERDATA = sh(script: "readlink -f userdata.tpl", returnStdout: true).trim()
    }

    sh 'printenv'
}

"userData.groovy"
def call(){
    dir("spw"){
        checkout scm: ([
                $class: 'GitSCM',
                userRemoteConfigs: [[credentialsId: 'bitbucket-devops',url: "ssh://git@internal-bitbucket-p-app-clb-621196423.us-east-1.elb.amazonaws.com/clddo/tfe-aws-${SUPPORTED_PRODUCT_WORKLOAD}.git"]],
                branches: [[name: "refs/tags/v${SUPPORTED_PRODUCT_WORKLOAD_VERSION}"]]
        ])
    }
}
"waasRepo.groovy"
def call(){
    sh '''
        echo "##[debug]Copy files..."
        cp userdata.tpl ./spw
        cp -r tfvars spw
        #cp -r tfvars ./spw
    '''
}
"tfFiles.groovy"
def call(){
    sh '''
        echo "####[debug] Creating provider.tf and backend.tf"
        chmod +x scripts/provider-backend-tf.sh

        sh ./scripts/provider-backend-tf.sh
    '''
}

"terraformPlan"
def call(){
    sh '''
        echo "####[debug] Terraform Plan"
        chmod +x scripts/terraform-plan.sh

        sh ./scripts/terraform-plan.sh
    '''
}
"terraformApply"
def call(){
    input message: 'Proceed to apply?', ok: 'Yes'

    try {
        sh '''
            echo "####[debug] Terraform apply!.."
            chmod +x scripts/terraform-apply.sh

            sh ./scripts/terraform-apply.sh
        '''
    } catch(e) {
        sh '''
            echo "####[debug] Terraform apply again!.."
            chmod +x scripts/terraform-apply.sh

            sh ./scripts/terraform-apply.sh
        '''
    }
}
"terraformDestroy"
def call(){

    try {
        sh '''
            echo "####[debug] Terraform Destroy!.."
            chmod +x scripts/terraform-destroy.sh

            sh ./scripts/terraform-destroy.sh
        '''
    } catch(e) {
        sh '''
            echo "####[debug] Terraform Destroy Again!..."
            chmod +x scripts/terraform-destroy.sh

            sh ./scripts/terraform-destroy.sh
        '''
    }
}
