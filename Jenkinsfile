pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = '2023bcs0159karthik' 
        // Your requested image name
        DOCKER_IMAGE = '2023bcs0159_jenkins_application' 
        // The ID of the key you stored in Jenkins
        DOCKER_CREDS_ID = 'dockerhub-credentials' 
        TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                // Jenkins automatically uses the GitHub Key you 'attached' to the Job UI
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
                    // This command pulls the DOCKER_HUB_USER and DOCKERHUB_PASS keys from Jenkins memory
                    withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDS_ID, 
                                     usernameVariable: 'D_USER', 
                                     passwordVariable: 'D_PASS')]) {
                        sh """
                        echo \$D_PASS | docker login -u \$D_USER --password-stdin
                        docker push ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG}
                        docker push ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest
                        docker logout
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."
            // Cleanup to ensure local Docker doesn't get cluttered
            sh "docker stop temp-test-${TAG} || true"
            sh "docker rm temp-test-${TAG} || true"
            sh "docker rmi ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} || true"
            sh "docker rmi ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest || true"
            cleanWs()
        }
    }
}