pipeline {
    agent any
    environment {
        AWS_REGION = 'eu-west-1'  // Set AWS region as needed
        STATE_FILE_PATH = '/path/to/local/terraform.tfstate'  // Path to your local state file
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
                // Initialize Terraform, using your local state file
                sh """
                terraform init
                """
            }
        }

        stage('Plan Terraform') {
            steps {
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'AWS_ACCESS_KEY' 
                ]]) {
                    script {
                        // Ensure AWS credentials are passed to the environment before running Terraform
                        sh """
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        export AWS_DEFAULT_REGION=$AWS_REGION
                        terraform plan -out=tfplan -state=${STATE_FILE_PATH}
                        """
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
                        // Apply the Terraform plan with injected AWS credentials and local state file
                        sh """
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        export AWS_DEFAULT_REGION=$AWS_REGION
                        terraform apply -auto-approve -state=${STATE_FILE_PATH} tfplan
                        """
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
