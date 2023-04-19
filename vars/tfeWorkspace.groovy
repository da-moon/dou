def call(String execution = 'none'){
    def TOKEN = '`cat ~/.terraformrc | grep "token" | tr -d \' " \' | awk -F \'token=\' \'{ print $2 }\' `'

    if (execution == 'create'){
        sh """
            set +x
            chmod +x ./scripts/create-tfe-workspace.sh ./scripts/attached-policy.sh

            echo "####[debug] Create TFE Workspace"
            sh ./scripts/create-tfe-workspace.sh ${TOKEN}
            
            echo "####[debug] Attach a policy set to workspace"
            sh ./scripts/attached-policy.sh ${TOKEN}
        """
    } else if (execution == 'delete'){
        sh """
            set +x
            echo "####[debug] Delete TFE Workspace"
            chmod +x ./scripts/delete-tfe-workspace.sh

            sh ./scripts/delete-tfe-workspace.sh ${TOKEN}
        """
    } else {
        sh 'echo "###[debug]Skipping workspace stage"'
    }
}