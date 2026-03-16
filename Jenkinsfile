pipeline {
    agent any

    environment {
        // Your confirmed username
        DOCKER_HUB_USER = '2023bcs0159karthik' 
        DOCKER_IMAGE = '2023bcs0159_jenkins_application' 
        TAG = "${env.BUILD_NUMBER}"
        // Your provided token
        DOCKER_PASS = 'dckr_pat_unSrx5Kx7gkgdAmxe4ccU2V-yKw'
    }

    stages {
        stage('Cleanup & Login') {
            steps {
                script {
                    sh "docker logout || true"
                    sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_HUB_USER} --password-stdin"
                }
            }
        }

        stage('Build & Tag') {
            steps {
                script {
                    echo "Building: ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG}"
                    sh "docker build -t ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} -t ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest ."
                }
            }
        }

        stage('Push') {
            steps {
                script {
                    echo "Pushing Version ${TAG} and latest..."
                    sh "docker push ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG}"
                    sh "docker push ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished. Cleaning local images..."
            sh "docker rmi ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} || true"
            sh "docker rmi ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest || true"
            cleanWs()
        }
    }
}