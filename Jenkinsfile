pipeline {
    agent any

    environment {
        AWS_REGION         = 'us-east-1'
        TF_VAR_key_name    = 'my-ssh-key'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Setup') {
            steps {
                withCredentials([
                    [$class: 'UsernamePasswordMultiBinding', credentialsId: 'AWS_CREDS', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY'],
                    string(credentialsId: 'TF_DB_PASSWORD', variable: 'TF_VAR_db_password')
                ]) {
                    dir('2tier-project') {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            terraform init -input=false
                        '''
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('2tier-project') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    [$class: 'UsernamePasswordMultiBinding', credentialsId: 'AWS_CREDS', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {
                    dir('2tier-project') {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            terraform plan -out=tfplan -input=false
                        '''
                        archiveArtifacts artifacts: 'tfplan'
                    }
                }
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
                withCredentials([
                    [$class: 'UsernamePasswordMultiBinding', credentialsId: 'AWS_CREDS', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {
                    dir('2tier-project') {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            terraform apply -input=false -auto-approve tfplan
                        '''
                    }
                }
            }
        }

        stage('Verify Deployment') {
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
            script {
                node {
                    cleanWs()
                }
            }
        }

        success {
            script {
                def alb_dns = sh(script: 'cd 2tier-project && terraform output -raw alb_dns_name', returnStdout: true).trim()
                echo "✅ Deployment successful! App URL: http://${alb_dns}"
            }
        }

        failure {
            echo '❌ Deployment failed! Check the logs for more details.'
        }
    }
}
