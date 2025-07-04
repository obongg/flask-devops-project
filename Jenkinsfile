pipeline {
    agent { label 'u1' }  

    environment {
        APP_ARCHIVE = 'build/flask-app.tar.gz'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }

        stage('Package Flask App') {
            steps {
                echo 'Running packaging script...'
                sh '''
                    chmod +x scripts/package.sh
                    ./scripts/package.sh
                '''
            }
        }

        stage('Verify Build Artifact') {
            steps {
                script {
                    if (!fileExists(env.APP_ARCHIVE)) {
                        error "Packaging failed! ${env.APP_ARCHIVE} not found."
                    } else {
                        echo "Packaging succeeded: ${env.APP_ARCHIVE} exists."
                    }
                }
            }
        }

        stage('Deploy via Ansible') {
            steps {
                echo 'Running Ansible playbook...'
                sh '''
                    ansible-playbook -i ansible/hosts.ini ansible/site.yml
                '''
            }
        }
    }

    post {
        success {
            echo '🚀 Deployment complete!'
        }
        failure {
            echo '❌ Deployment failed.'
        }
    }
}
