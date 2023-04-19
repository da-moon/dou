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
