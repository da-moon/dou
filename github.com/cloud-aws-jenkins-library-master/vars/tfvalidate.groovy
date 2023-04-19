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

    