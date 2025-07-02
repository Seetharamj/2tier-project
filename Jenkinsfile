pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_REGION           = 'us-east-1'
        TF_VAR_db_password   = credentials('DB_PASSWORD')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            steps {
                dir('2tier-project') {
                    sh 'terraform init'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                dir('2tier-project') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }
        
        stage('Terraform Apply') {
            when {
                branch 'main'
            }
            steps {
                dir('2tier-project') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
        
        stage('Terraform Destroy') {
            when {
                branch 'cleanup'
            }
            steps {
                dir('2tier-project') {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            script {
                if (env.BRANCH_NAME == 'main') {
                    def alb_dns = sh(script: 'cd 2tier-project && terraform output -raw alb_dns_name', returnStdout: true).trim()
                    echo "Application Load Balancer DNS: http://${alb_dns}"
                    
                    def rds_endpoint = sh(script: 'cd 2tier-project && terraform output -raw rds_endpoint', returnStdout: true).trim()
                    echo "RDS Endpoint: ${rds_endpoint}"
                }
            }
        }
    }
}
