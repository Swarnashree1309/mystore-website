pipeline {
    agent { label 'docker1 agent' }

    environment {
        IMAGE_NAME = "mystore-site"
        BLUE_CONTAINER = "mystore-blue"
        GREEN_CONTAINER = "mystore-green"
        ACTIVE_FILE = "/tmp/active_env"
    }

    stages {

        stage('Clone Repo') {
            steps {
                git branch: 'version1',
                    url: 'https://github.com/Swarnashree1309/mystore-website.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Determine Active Environment') {
            steps {
                script {
                    if (fileExists(env.ACTIVE_FILE)) {
                        ACTIVE = sh(script: "cat $ACTIVE_FILE", returnStdout: true).trim()
                    } else {
                        ACTIVE = "none"
                    }

                    if (ACTIVE == "blue-target") {
                        NEW_ENV = "Green-target"
                        NEW_CONTAINER = env.GREEN_CONTAINER
                        OLD_CONTAINER = env.BLUE_CONTAINER
                    } else {
                        NEW_ENV = "blue-target"
                        NEW_CONTAINER = env.BLUE_CONTAINER
                        OLD_CONTAINER = env.GREEN_CONTAINER
                    }

                    echo "Active: ${ACTIVE}"
                    echo "Deploying to: ${NEW_ENV}"
                }
            }
        }

        stage('Deploy to Inactive Environment') {
            steps {
                script {
                    sh """
                    docker stop ${NEW_CONTAINER} || true
                    docker rm ${NEW_CONTAINER} || true
                    docker run -d --name ${NEW_CONTAINER} ${IMAGE_NAME}
                    """
                }
            }
        }

        stage('Switch Traffic') {
            steps {
                script {
                    sh """
                    docker stop proxy || true
                    docker rm proxy || true
                    docker run -d -p 9090:80 --name proxy ${IMAGE_NAME}
                    """

                    sh "echo ${NEW_ENV} > ${ACTIVE_FILE}"
                }
            }
        }

        stage('Stop Old Environment') {
            steps {
                script {
                    sh """
                    docker stop ${OLD_CONTAINER} || true
                    docker rm ${OLD_CONTAINER} || true
                    """
                }
            }
        }
    }
}
