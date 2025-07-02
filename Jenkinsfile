pipeline {
  agent any
  environment {
    AWS_REGION = 'us-east-1'
  }

  stages {
    stage('Init') {
      steps {
        withCredentials([[
          $class: 'UsernamePasswordMultiBinding',
          credentialsId: 'AWS_CREDS',
          usernameVariable: 'AWS_ACCESS_KEY_ID',
          passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          sh 'terraform init'
        }
      }
    }
    stage('Plan') {
      steps {
        sh 'terraform plan -out=tfplan'
      }
    }
    stage('Apply') {
      steps {
        sh 'terraform apply -auto-approve tfplan'
      }
    }
  }

  post {
    always {
      cleanWs()
    }
  }
}
