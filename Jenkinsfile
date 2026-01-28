pipeline {
    agent any

    stages {

        stage('Clone Repo') {
            steps {
                git 'https://github.com/yourusername/your-repo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t mystore-site .'
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                docker stop mystore || true
                docker rm mystore || true
                docker run -d -p 8080:80 --name mystore mystore-site
                '''
            }
        }
    }
}

