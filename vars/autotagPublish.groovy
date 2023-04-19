def call(){
    def TOKEN = '`cat ~/.terraformrc | grep "token" | tr -d \' " \' | awk -F \'token=\' \'{ print $2 }\' `'

    git branch: "master",
            credentialsId: "bitbucket-devops",
            url: "ssh://git@internal-bitbucket-p-app-clb-621196423.us-east-1.elb.amazonaws.com/clddo/$REPO_NAME",
            changelog: true,
            poll: true

    sh """
        echo "####[debug] Create a new tag"
        chmod +x scripts/version-tag.sh

        sh ./scripts/version-tag.sh
    """

    sh """
        echo "####[debug] Publish module on TFE"
        set +x
        chmod +x scripts/tfe-private-module.sh
        
        sh ./scripts/tfe-private-module.sh ${TOKEN}
    """

    // wrap([$class: "MaskPasswordsBuildWrapper",
    //     varPasswordPairs: [[password: MY_PASSWORD] ]]) {
    //         echo "Password: ${MY_PASSWORD}"
    //         sh """
    //             set +x
    //             echo "####[debug] Publish module on TFE"
    //             chmod +x scripts/tfe-private-module.sh

    //             echo $REPO_NAME
            
    //             sh ./scripts/tfe-private-module.sh ${MY_PASSWORD}
    //         """
    // }

}