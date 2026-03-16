pipeline {
    agent any

    environment {
        // 1. MUST match your Docker Hub Login Name
        DOCKER_HUB_USER = '2023bcs0159karthik' 
        
        // 2. MUST match the EXACT Repo name on hub.docker.com
        DOCKER_IMAGE = '2023bcs0159_jenkins' 
        
        TAG = "${env.BUILD_NUMBER}"
        DOCKER_PASS = 'dckr_pat_unSrx5Kx7gkgdAmxe4ccU2V-yKw'
    }

    stages {
        stage('Build Image') {
            steps {
                // Build FIRST so the image exists locally before we even try to login
                sh "docker build -t ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} ."
                sh "docker tag ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest"
            }
        }

        stage('Docker Login') {
            steps {
                // Use single quotes around the password to prevent shell expansion issues
                sh "echo '${DOCKER_PASS}' | docker login -u ${DOCKER_HUB_USER} --password-stdin"
            }
        }

        stage('Push to Hub') {
            steps {
                sh "docker push ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG}"
                sh "docker push ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest"
            }
        }
    }

    post {
        always {
            sh "docker logout"
            // Clean up images so your Jenkins container doesn't run out of space
            sh "docker rmi ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:${TAG} || true"
            sh "docker rmi ${DOCKER_HUB_USER}/${DOCKER_IMAGE}:latest || true"
            cleanWs()
        }
    }
}