pipeline {
  agent { label 'docker-agent' }

  environment {
    REGISTRY = "docker.io"
    IMAGE    = "kalebcastillo/myapijenkins"
    // GIT_SHA_SHORT computed after checkout
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
              def img = docker.build("${IMAGE}:${env.GIT_SHA_SHORT}", ".")
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
      withCredentials([string(credentialsId: 'discord-webhook', variable: 'WEBHOOK')]) {
        sh '''
          curl -s -X POST -H "Content-Type: application/json" \
            -d "{\"content\": \"✅ ${JOB_NAME} #${BUILD_NUMBER} succeeded on ${BRANCH_NAME}\\nImage: ${IMAGE}:${GIT_SHA_SHORT}\"}" \
            "$WEBHOOK"
        '''
      }
    }
    failure {
      echo "❌ Build failed — check the console log."
      withCredentials([string(credentialsId: 'discord-webhook', variable: 'WEBHOOK')]) {
        sh '''
          curl -s -X POST -H "Content-Type: application/json" \
            -d "{\"content\": \"❌ ${JOB_NAME} #${BUILD_NUMBER} failed on ${BRANCH_NAME}\\nLogs: ${BUILD_URL}\"}" \
            "$WEBHOOK"
        '''
      }
    }
  }
}
