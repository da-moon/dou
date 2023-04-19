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
