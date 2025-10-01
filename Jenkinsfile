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
        
        stage('Build & Push') {
            steps {
                script {
                docker.withServer('tcp://127.0.0.1:2375') {
                docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
          def img = docker.build("kalebcastillo/myapijenkins:${env.GIT_SHA_SHORT}", ".")
          img.push()          // pushes :<sha>
          img.push('latest')  // pushes :latest
                  }
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
