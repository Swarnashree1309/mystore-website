pipeline {
    agent { label 'docker1 agent' } 

    stages {

        stage('Clone Repo') {
    steps {
        git branch: 'main',
            url: 'https://github.com/Swarnashree1309/mystore-website.git'
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
                docker run -d -p 9090:80 --name mystore mystore-site
                '''
            }
        }
    }
}

