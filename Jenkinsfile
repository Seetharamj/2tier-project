pipeline {
    agent any
    
    environment {
        // Credentials - verify these exist in Jenkins
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TF_VAR_db_password    = credentials('2TIER_RDS_MASTER_PASSWORD')
        AWS_REGION           = 'us-east-1'  // Explicit region setting
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
                                // Create this credential in Jenkins
                                credentialsId: 'GITHUB_CREDS',
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
                                    -backend-config="bucket=your-terraform-state-bucket" \
                                    -backend-config="key=2tier-project/terraform.tfstate" \
                                    -backend-config="region=${AWS_REGION}"
                            '''
                        } catch (err) {
                            error("Terraform init failed: ${err.message}")
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
                            sh 'terraform apply -auto-approve'
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
            cleanWs()
        }
        failure {
            echo 'Pipeline failed - check the build logs'
            // Basic notification since email isn't configured
        }
    }
}
