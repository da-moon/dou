def call(){
    sh '''
        echo "####[debug] Terraform Plan"
        chmod +x scripts/terraform-plan.sh

        sh ./scripts/terraform-plan.sh
    '''
}
