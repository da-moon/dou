def call(){
    sh '''
        echo "##[debug]Copy files..."
        cp userdata.tpl ./spw
        cp -r tfvars spw
        #cp -r tfvars ./spw
    '''
}
