pipeline {
    agent any

    environment {
        GIT_COMMIT_SHORT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
        IMAGE_NAME = "mon-site-react"
        CONTAINER_NAME = "mon-site-react"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build \
                      --build-arg GIT_COMMIT=${GIT_COMMIT_SHORT} \
                      -t ${IMAGE_NAME}:${GIT_COMMIT_SHORT} \
                      -t ${IMAGE_NAME}:latest .
                """
            }
        }

        stage('Stop & Remove ancien conteneur') {
            steps {
                sh 'docker rm -f ${CONTAINER_NAME} || true'
            }
        }

        stage('Deploy avec Docker Compose') {
            steps {
                sh """
                    IMAGE_TAG=${GIT_COMMIT_SHORT} \
                    docker compose up -d --no-deps web
                """
            }
        }

        stage('Test accès site') {
            steps {
                sh 'sleep 8'
                sh 'curl -f http://localhost:8080 || exit 1'
            }
        }
    }

    post {
        always {
            // Notification Slack (on simplifie si le token n'est pas encore bon)
            script {
                def color = currentBuild.result == 'SUCCESS' ? 'good' : 'danger'
                def message = "*${currentBuild.result ?: 'UNKNOWN'}* - ${env.JOB_NAME} #${env.BUILD_NUMBER}\n" +
                              "Commit: ${GIT_COMMIT_SHORT}\n" +
                              "<${env.BUILD_URL}|Voir les logs>\n" +
                              "Site → http://ton-ip-ou-domaine:8080"

                try {
                    slackSend(
                        channel: '#tp-jenkins',
                        color: color,
                        message: message
                    )
                } catch (Exception e) {
                    echo "Slack échoué (normal si pas encore configuré) : ${e}"
                }
            }

            // Nettoyage léger
            sh 'docker system prune -f --volumes || true'
        }
    }
}
