pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TF_VAR_db_password    = credentials('TF_DB_PASSWORD')
        TF_VAR_key_name       = 'my-ssh-key'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'terraform version'
            }
        }
        
        stage('Terraform Init') {
            steps {
                sh '''
                cd 2tier-project
                terraform init -input=false -backend-config="bucket=my-terraform-state-bucket" -backend-config="key=2tier-project/terraform.tfstate"
                '''
            }
        }
        
        stage('Terraform Validate') {
            steps {
                sh 'cd 2tier-project && terraform validate'
            }
        }
        
        stage('Terraform Plan') {
            steps {
                sh 'cd 2tier-project && terraform plan -out=tfplan -input=false'
                archiveArtifacts artifacts: '2tier-project/tfplan'
            }
        }
        
        stage('Manual Approval') {
            when { branch 'main' }
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input message: 'Apply Terraform changes?', ok: 'Apply'
                }
            }
        }
        
        stage('Terraform Apply') {
            when { branch 'main' }
            steps {
                sh 'cd 2tier-project && terraform apply -input=false -auto-approve tfplan'
            }
        }
        
        stage('Infrastructure Tests') {
            steps {
                script {
                    def alb_dns = sh(script: 'cd 2tier-project && terraform output -raw alb_dns_name', returnStdout: true).trim()
                    sh "curl -s -o /dev/null -w '%{http_code}' http://${alb_dns} | grep 200"
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
                def alb_dns = sh(script: 'cd 2tier-project && terraform output -raw alb_dns_name', returnStdout: true).trim()
                slackSend(color: 'good', message: "2-Tier deployment successful!\nApplication URL: http://${alb_dns}")
            }
        }
        failure {
            slackSend(color: 'danger', message: "2-Tier deployment failed in ${env.STAGE_NAME}")
        }
    }
}
