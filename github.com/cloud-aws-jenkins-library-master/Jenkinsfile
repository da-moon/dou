pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION="us-east-2"
    }
    stages {
        stage('Get Author Name'){
            when{ expression {env.GIT_AUTHOR != 'Jenkins CI' && env.BRANCH_NAME == 'master'} }
            steps{
                script{
                    env.GIT_AUTHOR = sh(script: "eval git --no-pager show -s --format=\'%an\'", returnStdout: true).trim()
                }
            }
        }
        stage('Checkout Code') {
            when{ expression {env.GIT_AUTHOR != 'Jenkins CI'} }
            steps{
                git changelog: false,
                  credentialsId: 'bitbucket-devops',
                  poll: false,
                  url: 'ssh://git@internal-bitbucket-p-app-clb-621196423.us-east-1.elb.amazonaws.com/clddo/cloud-aws-jenkins-library.git',
                  branch: env.BRANCH_NAME
            }
        }
        stage('Create tag'){
            when{ expression {env.GIT_AUTHOR != 'Jenkins CI' && env.BRANCH_NAME == 'master'} }
            steps {
               sh """
                git fetch --tags --depth=1000 --prune
                if [ `git rev-parse --abbrev-ref HEAD` != "master" ]
                then
                  git branch --track master origin/master
                fi
                git-chglog --next-tag `autotag -n` -o CHANGELOG.md
                git config user.name 'Jenkins CI'
                git add CHANGELOG.md; git commit -m "updated CHANGELOG"; git push --set-upstream origin master
                autotag; git push origin --tags
                """
            }
        }
    }
    post {
        always {
          echo "Cleaning up Workspace"
          deleteDir() /* clean up our workspace */
        }
    }
}
