]pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TF_VAR_db_password    = credentials('2TIER_RDS_MASTER_PASSWORD')
        AWS_REGION           = 'us-east-1'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    extensions: [[
                        $class: 'RelativeTargetDirectory',
                        relativeTargetDir: 'terraform'  // Checkout directly into terraform/
                    ]],
                    userRemoteConfigs: [[
                        credentialsId: 'GIT_CREDENTIALS',  // MUST be created in Jenkins
                        url: 'https://github.com/Seetharamj/2tier-project.git'
                    ]]
                ])
            }
        }
        
        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform init \
                            -backend-config="bucket=your-terraform-state-bucket" \
                            -backend-config="key=2tier-project/terraform.tfstate" \
                            -backend-config="region=${AWS_REGION}"
                    '''
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
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
        }
    }
}
