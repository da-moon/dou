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
