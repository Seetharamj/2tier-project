pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TF_VAR_db_password    = credentials('2TIER_RDS_MASTER_PASSWORD')
        AWS_REGION            = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                    terraform init \
                        -backend-config="bucket=seetharam-terraform-108108" \
                        -backend-config="key=2tier-project/terraform.tfstate" \
                        -backend-config="region=us-east-1"
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }

   
    post {
        always {
            cleanWs()
        }
        failure {
            echo '❌ Pipeline failed - check logs'
        }
    }
}
