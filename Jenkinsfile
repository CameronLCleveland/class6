pipeline { 
    agent any
    environment {
        AWS_REGION = 'eu-west-1'  // Set AWS region as needed
    }
    stages {
        stage('Set AWS Credentials') {
            steps {
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'AWS_ACCESS_KEY'  // Ensure this matches the credentials in Jenkins
                ]]) {
                    script {
                        // AWS credentials are injected into the environment
                        echo "AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID"
                        echo "AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY"
                        // Test AWS credentials by running AWS CLI to verify they work
                        sh 'aws sts get-caller-identity'
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
                // Initialize Terraform, no need for Docker or AWS CLI here
                sh 'terraform init'
            }
        }

        stage('Refresh Terraform State') {
            steps {
                withCredentials([[ 
                    $class
