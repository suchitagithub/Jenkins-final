pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {
        stage('Git checkout') {
            steps {
                
                git branch: 'main', url: 'https://github.com/Sonal-BP/jekinstasks.git'
            }
        }
        
        stage('Initiating terraform') {
            steps {
                    sh 'terraform init'
            }
        }
        
        stage('resource planning') {
            steps {
                    sh 'terraform plan'
            }
        }
        
        stage('applying resources') {
            steps {
                    sh 'terraform apply -auto-approve'
            }
        }
    }
}
