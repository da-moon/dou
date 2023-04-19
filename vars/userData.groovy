def call(){
    dir("spw"){
        checkout scm: ([
                $class: 'GitSCM',
                userRemoteConfigs: [[credentialsId: 'bitbucket-devops',url: "ssh://git@internal-bitbucket-p-app-clb-621196423.us-east-1.elb.amazonaws.com/clddo/tfe-aws-${SUPPORTED_PRODUCT_WORKLOAD}.git"]],
                branches: [[name: "refs/tags/v${SUPPORTED_PRODUCT_WORKLOAD_VERSION}"]]
        ])
    }
}
