
def call(){
    dir("fmt"){
        checkout scm: ([
                $class: 'GitSCM',
                userRemoteConfigs: [[credentialsId: 'bitbucket-devops',url: "ssh://git@internal-bitbucket-p-app-clb-621196423.us-east-1.elb.amazonaws.com/clddo/${REPO_NAME}.git"]],
                branches: [[name: "${BRANCH_NAME}"]]
        ])
    }

        sh '''
            echo "####[debug] Run Terraform Format"
            chmod +x scripts/terraform-fmt.sh

            sh ./scripts/terraform-fmt.sh
        '''

}




