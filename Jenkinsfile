pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = '2023bcs0159karthik' 
        DOCKER_IMAGE = '2023bcs0159_jenkins_application' 
        DOCKER_PASS = 'dckr_pat_unSrx5Kx7gkgdAmxe4ccU2V-yKw'
        TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Login') {
            steps {
                script {
                    echo "Building and Logging in..."
                    sh "docker build -t ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} ."
                    sh "docker tag ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest"
                    // Login using the provided token
                    sh "echo '${DOCKER_PASS}' | docker login -u ${DOCKER_HUB_USER} --password-stdin"
                }
            }
        }

        stage('Push') {
            steps {
                script {
                    echo "Pushing Image..."
                    sh "docker push ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG}"
                    sh "docker push ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest"
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up..."
            sh "docker logout"
            sh "docker rmi ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} || true"
            sh "docker rmi ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest || true"
            cleanWs()
        }
    }
}