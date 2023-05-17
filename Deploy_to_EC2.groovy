pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your-repo.git'
            }
        }
        
        stage('Build') {
            steps {
                // Build your application 
                sh 'mvn clean install' 
            }
        }
        
        stage('Deploy') {
            steps {
                // Deploy the application to the EC2 instance
                withAWS(credentials: 'aws-credentials') {
                    sh 'aws configure set region us-west-2'
                    sh 'aws s3 cp target/my-app.jar s3://artifact/'
                    sh 'aws ec2 stop-instances --instance-ids yi-0567924d5627215ab'
                    sh 'aws s3 cp s3://your-bucket/my-app.jar /var/www/html/'
                    sh 'aws ec2 start-instances --instance-ids yi-0567924d5627215ab'
                }
            }
        }
    }
}
