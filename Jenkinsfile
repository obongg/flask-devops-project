pipeline {
    agent { label 'u1' }

    environment {
        APP_ARCHIVE = 'build/flask-app.tar.gz'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo '📥 Cloning repository...'
                checkout scm
            }
        }

        stage('Package Flask App') {
            steps {
                echo '📦 Packaging Flask app...'
                sh '''
                    chmod +x scripts/package.sh
                    ./scripts/package.sh
                '''

                echo '📂 Archiving build artifact...'
                archiveArtifacts artifacts: "${APP_ARCHIVE}", fingerprint: true
                stash includes: "${APP_ARCHIVE}", name: 'flask-artifact'
            }
        }

        stage('Verify Build Artifact') {
            steps {
                script {
                    if (!fileExists(env.APP_ARCHIVE)) {
                        echo '🛑 Artifact not found. Showing directory contents for debugging:'
                        sh 'ls -R'
                        error "Packaging failed! ${env.APP_ARCHIVE} not found."
                    } else {
                        echo "✅ Packaging succeeded: ${env.APP_ARCHIVE} exists."
                    }
                }
            }
        }

        stage('Deploy via Ansible') {
            steps {
                echo '📦 Unstashing build artifact before deployment...'
                unstash 'flask-artifact'

                echo '🚀 Running Ansible playbook...'
                sh '''
                    ansible-playbook -i ansible/hosts.ini ansible/site.yml
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Deployment complete!'
        }
        failure {
            echo '❌ Deployment failed.'
        }
    }
}
