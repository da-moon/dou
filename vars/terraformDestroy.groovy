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
