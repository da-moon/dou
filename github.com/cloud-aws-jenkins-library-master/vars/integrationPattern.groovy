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
