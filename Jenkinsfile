pipeline {
    agent any
    
    environment {
        // Required credentials (create these in Jenkins Credentials Store)
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TF_VAR_db_password    = credentials('RDS_DB_PASSWORD')  // Changed from TF_VAR_db_password to be more explicit
        TF_STATE_BUCKET      = 'your-terraform-state-bucket'   // Define these or use Jenkins credentials
        TF_STATE_KEY         = '2tier-project/terraform.tfstate'
    }
    
    stages {
        stage('Checkout') {
            steps {
                script {
                    try {
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: '*/main']],
                            extensions: [],
                            userRemoteConfigs: [[
                                credentialsId: 'GIT_CREDENTIALS', // Must create this credential
                                url: 'https://github.com/Seetharamj/2tier-project.git'
                            ]]
                        ])
                    } catch (err) {
                        error("Checkout failed: ${err.message}")
                    }
                }
            }
        }
        
        stage('Terraform Init') {
            steps {
                dir('./terraform') {
                    script {
                        try {
                            sh '''
                                terraform init \
                                    -backend-config="bucket=${TF_STATE_BUCKET}" \
                                    -backend-config="key=${TF_STATE_KEY}" \
                                    -backend-config="region=us-east-1"
                            '''
                        } catch (err) {
                            error("Terraform init failed: ${err.message}")
                        }
                    }
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                dir('./terraform') {
                    script {
                        try {
                            sh 'terraform plan -out=tfplan -input=false'
                        } catch (err) {
                            // Plan may exit with code 2 if there are changes
                            if (err.toString().contains('exit code 2')) {
                                echo 'Terraform plan shows changes'
                            } else {
                                error("Terraform plan failed: ${err.message}")
                            }
                        }
                    }
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                dir('./terraform') {
                    script {
                        try {
                            sh 'terraform apply -auto-approve -input=false tfplan'
                        } catch (err) {
                            error("Terraform apply failed: ${err.message}")
                        }
                    }
                }
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
            emailext (
                subject: "FAILED: Job '${env.JOB_NAME}' (${env.BUILD_NUMBER})",
                body: "Check console output at ${env.BUILD_URL}",
                to: 'your-email@example.com'
            )
        }
    }
}
