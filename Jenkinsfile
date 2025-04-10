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
                    sh '''
                    echo "AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID"
                    docker run --rm \
                        -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
                        -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
                        amazon/aws-cli sts get-caller-identity
                    '''
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
                    sh '''
                    docker run --rm \
                        -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
                        -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
                        amazon/aws-cli sts get-caller-identity
                    '''
                    sh "terraform init"
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'AWS_ACCESS_KEY' 
                ]]) {
                    sh '''
                    docker run --rm \
                        -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
                        -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
                        amazon/aws-cli sts get-caller-identity
                    '''
                    sh 'terraform plan -out=tfplan'
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
                    sh '''
                    docker run --rm \
                        -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
                        -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
                        amazon/aws-cli sts get-caller-identity
                    '''
                    sh 'terraform apply -auto-approve tfplan'
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


