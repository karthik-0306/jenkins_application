pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = '2023bcs0159karthik' 
        DOCKER_IMAGE = '2023bcs0159_jenkins_application' 
        DOCKER_PASS = 'dckr_pat_vTRguo4uWE2O5VsIeRWx9kMqqNg'
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
                    echo "Building Image version ${TAG}..."
                    sh "docker build -t ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} ."
                    sh "docker tag ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest"
                    
                    echo "Attempting Docker Hub Login..."
                    // printf is safer than echo for tokens
                    sh "printf '${DOCKER_PASS}' | docker login -u ${DOCKER_HUB_USER} --password-stdin"
                }
            }
        }

        stage('Push') {
            steps {
                script {
                    echo "Pushing to Docker Hub..."
                    sh "docker push ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG}"
                    sh "docker push ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest"
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up local environment..."
            sh "docker logout"
            sh "docker rmi ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} || true"
            sh "docker rmi ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest || true"
            cleanWs()
        }
    }
}