def call(){
    tfeWorkspace 'create'

    sh '''
      export whereIam=$(pwd)

      cd test

      chmod +x ../scripts/replace-module.sh
      echo "####[debug] Replace path of the module"
      sh ../scripts/replace-module.sh
  '''

    dir('test'){
        sh '''
            chmod +x ../scripts/override-backend.sh ../scripts/export-tfvars.sh

            echo "####[debug] Create backend"
            sh ../scripts/override-backend.sh
            sh ../scripts/export-tfvars.sh
        '''

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
