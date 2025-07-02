pipeline {
    agent any
    
    environment {
        // Use your existing credential ID exactly as created
        TF_VAR_db_password = credentials('2TIER_RDS_MASTER_PASSWORD')
        
        // Other environment variables
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Seetharamj/2tier-project.git',
                        credentialsId: 'GITHUB_CREDS' // Ensure this exists
                    ]]
                ])
            }
        }
        
        stage('Terraform Apply') {
            steps {
                sh '''
                    terraform init
                    terraform apply -auto-approve
                '''
            }
        }
    }
    
    post {
        always {
            script {
                // Clean workspace only if we have node context
                if (env.NODE_NAME != null) {
                    cleanWs()
                } else {
                    echo 'Skipping workspace clean: no node context'
                }
            }
        }
        failure {
            echo 'Pipeline failed - please check the build logs for errors'
            mail to: '007herohero@gmail.com',
                 subject: "Pipeline Failed: ${currentBuild.fullDisplayName}",
                 body: "Check console output at ${env.BUILD_URL}"
        }
    }
}
