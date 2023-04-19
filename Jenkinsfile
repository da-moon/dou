//
// Pipeline code to validate/latestversion/plan/integrationtest/tagging/publishing terraform code
//
def call() {
    pipeline {
        agent any
        environment {
            AWS_DEFAULT_REGION="us-east-1"
        }
        parameters {
            choice(choices: ['False', 'True'], description: 'Skipping `terraform validate` stage', name: 'SKIP_TF_VALIDATE')
            choice(choices: ['False', 'True'], description: 'Skipping `Compare the latest version` stage', name: 'SKIP_LATEST_VERSION')
            string(defaultValue: "terraform-cldsvc-prod.corp.internal.companyA.com", description: 'Terraform Enterprise hostname', name: 'TFE_HOST')
            string(defaultValue: "cfg-cloud-services", description: 'Terraform Enterprise organization', name: 'TFE_ORG')
            string(defaultValue: "prod", description: 'Indicates the environment where the infrastructure will be deployed, and the config files should take (by example the prod.tfvars file)', name: 'ENV_NAME')
        }
        stages {
            stage("Set up env"){
                steps{
                    script{
                        env.GIT_AUTHOR = sh(script: "eval git log -1 --pretty=format:'%an'", returnStdout: true).trim()
                        env.REPO_NAME = env.GIT_URL.replaceFirst(/^.*\/([^\/]+?).git$/, '$1')
                        if (!env.BRANCH_NAME){
                            env.BRANCH_NAME = "${GIT_BRANCH.split("origin/")[1]}" // - already created in the pipeline
                        }
                        env.BRANCH_WS = env.BRANCH_NAME.replaceAll('/', '-')
                        env.TFE_WORKSPACE = sh(script: "eval echo '$REPO_NAME-$BUILD_ID-integration-$BRANCH_WS'", returnStdout: true).trim()
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
            stage("Compare the latest version"){
                when{ expression {env.SKIP_LATEST_VERSION == 'False' } }
                steps{
                    clonePattern()
                }
            }
            stage("Terraform Plan"){
                steps{
                    tfintegrationPlan()
                }
                post {
                    failure {
                        tfeWorkspace 'delete'
                    }
                }
            }
            stage("Integration Tests"){
                steps{
                    integrationPattern()
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

"tfvalidate.groovy"
def call(){

    sh '''
        echo "####[debug] Terraform TFLint"
        chmod +x scripts/terraform-lint.sh

        export tflint_config="scripts/.tflint.hcl"
        sh ./scripts/terraform-lint.sh
    '''

    try {
        sh '''
            echo "####[debug] Terraform Validate"
            chmod +x scripts/terraform-validate.sh

            sh ./scripts/terraform-validate.sh
        '''
    } catch(e) {
        terraformFmt()
    }

}

"clonePattern.groovy"
def call(){
    script{
        env.LATEST_VERSION = sh(script: "eval git tag | sort -V | tail -1", returnStdout: true).trim()
    }

    tfeWorkspace 'create'

    if (env.LATEST_VERSION != ""){
        dir("latestVersion"){
            checkout scm: ([
                    $class: 'GitSCM',
                    userRemoteConfigs: [[credentialsId: 'bitbucket-devops',url: "ssh://git@internal-bitbucket-p-app-clb-621196423.us-east-1.elb.amazonaws.com/clddo/${REPO_NAME}.git"]],
                    branches: [[name: "refs/tags/${LATEST_VERSION}"]]
            ])
           
            catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE', message: "THE TERRATEST TEST CASES FAILED"){
                sh '''
                    export whereIam=$(pwd)

                    cd integration_test

                    chmod +x ../../scripts/terratest.sh ../../scripts/export-tfvars.sh ../../scripts/replace-module.sh ../../scripts/override-backend.sh
                    echo "####[debug] Replace path of the module"
                    sh ./../../scripts/replace-module.sh
                   
                    echo "####[debug] Create backend"
                    sh ./../../scripts/override-backend.sh

                    echo "###[debug] SKIP --> INTERNAL_TESTS and TEARDOWN stages"
                    export SKIP_INTERNAL_TESTS=true
                    export SKIP_TEARDOWN=true

                    echo "####[debug] Run Terratest"
                    sh ./../../scripts/export-tfvars.sh
                    sh ./../../scripts/terratest.sh
                '''
            }
        }
    }

}

"tfintegrationPlan.groovy"
def call(){

  if (env.SKIP_LATEST_VERSION == 'True'){
    tfeWorkspace 'create'
  }

  sh '''
      export whereIam=$(pwd)

      cd integration_test

      chmod +x ../scripts/replace-module.sh
      echo "####[debug] Replace path of the module"
      sh ./../scripts/replace-module.sh
  '''

  dir('integration_test'){
    sh '''
        echo "####[debug] Create backend"
        chmod +x ../scripts/override-backend.sh
        sh ./../scripts/override-backend.sh
    '''

    sh '''
        echo "####[debug] Terraform Plan"
        chmod +x ../scripts/terraform-plan-internal.sh ../scripts/export-tfvars.sh

        sh ../scripts/export-tfvars.sh
        sh ../scripts/terraform-plan-internal.sh
    '''
  }
}

"integrationPattern.groovy"
def call(){
    dir('integration_test'){
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE', message: "THE TERRATEST TEST CASES FAILED"){
            sh '''
                echo "####[debug] Run Terratest"
                chmod +x ../scripts/terratest.sh

                sh ./../scripts/terratest.sh
            '''
        }
    }

    tfeWorkspace 'delete'
}

"autotagPublish.groovy"
def call(){
    def TOKEN = '`cat ~/.terraformrc | grep "token" | tr -d \' " \' | awk -F \'token=\' \'{ print $2 }\' `'

    git branch: "master",
            credentialsId: "bitbucket-devops",
            url: "ssh://git@internal-bitbucket-p-app-clb-621196423.us-east-1.elb.amazonaws.com/clddo/$REPO_NAME",
            changelog: true,
            poll: true

    sh """
        echo "####[debug] Create a new tag"
        chmod +x scripts/version-tag.sh

        sh ./scripts/version-tag.sh
    """

    sh """
        echo "####[debug] Publish module on TFE"
        set +x
        chmod +x scripts/tfe-private-module.sh
       
        sh ./scripts/tfe-private-module.sh ${TOKEN}
    """

    // wrap([$class: "MaskPasswordsBuildWrapper",
    //     varPasswordPairs: [[password: MY_PASSWORD] ]]) {
    //         echo "Password: ${MY_PASSWORD}"
    //         sh """
    //             set +x
    //             echo "####[debug] Publish module on TFE"
    //             chmod +x scripts/tfe-private-module.sh

    //             echo $REPO_NAME
           
    //             sh ./scripts/tfe-private-module.sh ${MY_PASSWORD}
    //         """
    // }

}
