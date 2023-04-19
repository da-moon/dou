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
