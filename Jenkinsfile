pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_REGION            = 'us-east-1'
        TF_VAR_db_password    = credentials('TF_DB_PASSWORD')
        TF_VAR_key_name       = 'my-ssh-key'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform --version'
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan -input=false'
                archiveArtifacts artifacts: 'tfplan'
            }
        }

        stage('Manual Approval') {
            when { branch 'main' }
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    input message: 'Approve apply?', ok: 'Yes'
                }
            }
        }

        stage('Terraform Apply') {
            when { branch 'main' }
            steps {
                sh 'terraform apply -input=false -auto-approve tfplan'
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    def alb_dns = sh(script: 'terraform output -raw alb_dns_name', returnStdout: true).trim()
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
                def alb_dns = sh(script: 'terraform output -raw alb_dns_name', returnStdout: true).trim()
                echo "✅ Deployment successful! Visit: http://${alb_dns}"
            }
        }
        failure {
            echo '❌ Deployment failed. Check logs for details.'
        }
    }
}
