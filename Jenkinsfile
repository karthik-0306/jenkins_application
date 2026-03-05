pipeline {
    agent any
    
    // Environment variables
    environment {
      DOCKER_HUB_USER = '2023bcs0159karthik' 
      DOCKER_IMAGE = 'jenkins-frontend-app' 
      DOCKER_CREDS_ID = 'dckr_pat_unSrx5Kx7gkgdAmxe4ccU2V-yKw' 

      TAG = "${env.BUILD_NUMBER}"
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
                    echo "Building Docker Image: ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG}..."
                    sh "docker build -t ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} -t ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest ."
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    echo "Testing if the container runs..."
                    // Start the container, wait a moment, and ensure it is up
                    sh """
                        docker run -d --name temp-test-${TAG} -p 8085:80 ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG}
                       
                    """
                }
            }
        }
    stage('Push Docker Image') {
    steps {
        script {
            echo "Pushing Docker Image to Docker Hub..."

            withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDS_ID, usernameVariable: 'DOCKER_HUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                sh """
                echo \$DOCKERHUB_PASS | docker login -u ${DOCKER_HUB_USER} --password-stdin
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
            cleanWs()
            sh "docker rmi ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} || true"
            sh "docker rmi ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest || true"
        }
        success {
            echo "Build and Push was successful!"
        }
        failure {
            echo "Build or Push failed."
        }
    }
}


