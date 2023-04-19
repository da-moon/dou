def call(){
    sh '''
        echo "####[debug] Creating provider.tf and backend.tf"
        chmod +x scripts/provider-backend-tf.sh

        sh ./scripts/provider-backend-tf.sh
    '''
}