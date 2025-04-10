pipeline {
    agent any
    environment {
        AWS_REGION = 'eu-west-1'
    }
    stages {
        stage('Set AWS Credentials') {
            steps {
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'AWS_ACCESS_KEY' 
                ]]) {
                    script {
                        // Use environment variables explicitly for both AWS CLI and Terraform
                        withEnv([
                            "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}",
                            "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}",
                            "AWS_DEFAULT_REGION=${AWS_REGION}"
                        ]) {
                            // Running AWS CLI inside a Docker container with AWS credentials
                            docker.image('amazon/aws-cli').inside {
                                sh '''
                                echo "AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID"
                                aws sts get-caller-identity
                                '''
                            }
                        }
                    }
                }
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/CameronLCleveland/class6.git'
            }
        }

        stage('Initialize Terraform') {
            steps {
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'AWS_ACCESS_KEY' 
                ]]) {
                    script {
                        withEnv([
                            "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}",
                            "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}",
                            "AWS_DEFAULT_REGION=${AWS_REGION}"
                        ]) {
                            // Running AWS CLI inside a Docker container with AWS credentials
                            docker.image('amazon/aws-cli').inside {
                                sh 'aws sts get-caller-identity'
                            }

                            // Running Terraform inside a Docker container with AWS credentials
                            docker.image('hashicorp/terraform:latest').inside {
                                sh 'terraform init'
                            }
                        }
                    }
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'AWS_ACCESS_KEY' 
                ]]) {
                    script {
                        withEnv([
                            "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}",
                            "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}",
                            "AWS_DEFAULT_REGION=${AWS_REGION}"
                        ]) {
                            // Running AWS CLI inside a Docker container with AWS credentials
                            docker.image('amazon/aws-cli').inside {
                                sh 'aws sts get-caller-identity'
                            }

                            // Running Terraform inside a Docker container with AWS credentials
                            docker.image('hashicorp/terraform:latest').inside {
                                sh 'terraform plan -out=tfplan'
                            }
                        }
                    }
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                input message: "Approve Terraform Apply?", ok: "Deploy"
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'AWS_ACCESS_KEY' 
                ]]) {
                    script {
                        withEnv([
                            "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}",
                            "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}",
                            "AWS_DEFAULT_REGION=${AWS_REGION}"
                        ]) {
                            // Running AWS CLI inside a Docker container with AWS credentials
                            docker.image('amazon/aws-cli').inside {
                                sh 'aws sts get-caller-identity'
                            }

                            // Running Terraform inside a Docker container with AWS credentials
                            docker.image('hashicorp/terraform:latest').inside {
                                sh 'terraform apply -auto-approve tfplan'
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform deployment completed successfully!'
        }
        failure {
            echo 'Terraform deployment failed!'
        }
    }
}
