pipeline {
    agent any

    stages {

        stage('Clone Repo') {
    steps {
        git branch: 'main',
            url: 'https://github.com/anu-rb06/mystore-website.git'
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

