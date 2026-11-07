pipeline {
    agent {
        label 'linux && podman'
    }

    triggers {
        pollSCM('H/5 * * * *')
    }

    environment {
        REGISTRY = 'registry.assign.jzamor-villela.300.ops:5000'
        IMAGE_NAME = 'bind-secondary'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Image') {
            steps {
                sh '''
                    podman build -t ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} .
                    podman tag ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} \
                        ${REGISTRY}/${IMAGE_NAME}:latest
                '''
            }
        }

        stage('Registry Login and Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'registry-credentials',
                        usernameVariable: 'REGISTRY_USER',
                        passwordVariable: 'REGISTRY_PASSWORD'
                    )
                ]) {
                    sh '''
                        set +x
                        printf '%s' "$REGISTRY_PASSWORD" | \
                            podman login "$REGISTRY" \
                            --username "$REGISTRY_USER" \
                            --password-stdin

                        podman push ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}
                        podman push ${REGISTRY}/${IMAGE_NAME}:latest

                        podman logout "$REGISTRY"
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'BIND secondary pipeline completed.'
        }
    }
}
