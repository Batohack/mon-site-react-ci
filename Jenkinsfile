pipeline {
    agent any

    environment {
        GIT_COMMIT_SHORT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
        DOCKER_IMAGE = "mon-site-react"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build React + Docker') {
            steps {
                sh '''
                    docker compose build --build-arg GIT_COMMIT=${GIT_COMMIT_SHORT}
                '''
            }
        }

        stage('Stop ancien conteneur') {
            steps {
                sh 'docker compose down || true'
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker compose up -d'
            }
        }

        stage('Test accès site') {
            steps {
                sh 'sleep 5'
                sh 'curl -f http://localhost:8080 || exit 1'
            }
        }
    }

    post {
        always {
            slackSend(
                channel: '#tp-jenkins',
                color: currentBuild.result == 'SUCCESS' ? 'good' : 'danger',
                message: "*${currentBuild.result}* - ${env.JOB_NAME} #${env.BUILD_NUMBER}\nCommit: ${GIT_COMMIT_SHORT}\n<${env.BUILD_URL}|Voir les logs Jenkins>\nSite: http://ton-serveur:8080"
            )
        }
        cleanup {
            sh 'docker compose down || true'
            sh 'docker system prune -f'
        }
    }
}
