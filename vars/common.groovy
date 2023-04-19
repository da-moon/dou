def call(){
    def SHAREDLIBRARY_BRANCH = env."library.cloud-aws-jenkins-library.version"
    
    sh """
        echo "Cloning shared library on ${SHAREDLIBRARY_BRANCH}"
    """

    dir("sharedlib"){
        git branch: "${SHAREDLIBRARY_BRANCH}",
            credentialsId: 'bitbucket-devops',
            url: 'ssh://git@internal-bitbucket-p-app-clb-621196423.us-east-1.elb.amazonaws.com/clddo/cloud-aws-jenkins-library.git',
            changelog: false,
            poll: false
    }
    sh '''
        echo "##[debug]Find the terraform folder..."
        folder=`find . -type d -name "terraform"`
        cp -r $folder scripts
    '''
}
