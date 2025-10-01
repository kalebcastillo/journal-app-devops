pipeline {
    agent { label 'docker-agent' }
    
    environment {
        REGISTRY = "docker.io"
        IMAGE= "kalebcastillo/myapijenkins"
    }
    
    stages {
        
        stage('Checkout') {
            steps {
                checkout scm                                  

                // Compute short git SHA now that we have the repo
                script {
                env.GIT_SHA_SHORT = sh(
                    script: 'git rev-parse --short=7 HEAD',
                    returnStdout: true
                ).trim()
                }
                echo "Tag for this build: ${env.GIT_SHA_SHORT}"
            }
        }
        
        stage('Test') {
            steps {
                echo "Testing..."
                sh '''
                echo "Testing code..."
                '''
            }
        }
        
          stage('Build image') {
            steps {
                script {
                    def img = docker.build("${IMAGE}:${GIT_SHA_SHORT}", ".")
                    sh "docker tag ${IMAGE}:${GIT_SHA_SHORT} ${IMAGE}:latest"
                }
            }
        }

        stage('Push Docker image') {
            steps {
                script {
                    // Use Jenkins Docker Pipeline integration to login with your credentials
                    docker.withRegistry("https://${REGISTRY}", 'dockerhub-creds') {
                        sh """
                          # Push both tags to Docker Hub
                          docker push ${IMAGE}:${GIT_SHA_SHORT}
                          docker push ${IMAGE}:latest
                        """
                    }
                }
            }
        }
    
        stage('Deliver') {
            steps {
                echo 'Delivering...'
                sh '''
                echo "App deployed!"
                '''
            }
        }
    }
    
    post {
        success {
            echo "✅ Pushed ${IMAGE}:${GIT_SHA_SHORT} and ${IMAGE}:latest"
        }
        failure {
            echo "❌ Build failed — check the console log."
        }
    }
}
