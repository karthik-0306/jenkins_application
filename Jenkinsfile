pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = '2023bcs0159karthik' 
        DOCKER_IMAGE = '2023bcs0159_jenkins_application' 
        TAG = "${env.BUILD_NUMBER}"
        // Directly injecting the token
        DOCKER_PASS = 'dckr_pat_unSrx5Kx7gkgdAmxe4ccU2V-yKw'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Image: ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG}"
                    sh "docker build -t ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} -t ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest ."
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    echo "Testing if the container runs..."
                    sh "docker run -d --name temp-test-${TAG} -p 8085:80 ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG}"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo "Pushing to Docker Hub..."
                    // Using the environment variable directly for login
                    sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_HUB_USER} --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG}"
                    sh "docker push ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest"
                    sh "docker logout"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."
            // Cleanup local containers and images
            sh "docker stop temp-test-${TAG} || true"
            sh "docker rm temp-test-${TAG} || true"
            sh "docker rmi ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} || true"
            sh "docker rmi ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest || true"
            cleanWs()
        }
    }
}