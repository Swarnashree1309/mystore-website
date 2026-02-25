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
                git branch: 'main',
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
                    def ACTIVE = "none"
                    if (fileExists(env.ACTIVE_FILE)) {
                        ACTIVE = sh(script: "cat $ACTIVE_FILE", returnStdout: true).trim()
                    }

                    def NEW_ENV
                    def NEW_CONTAINER
                    def OLD_CONTAINER

                    if (ACTIVE == "blue") {
                        NEW_ENV = "green"
                        NEW_CONTAINER = env.GREEN_CONTAINER
                        OLD_CONTAINER = env.BLUE_CONTAINER
                    } else {
                        NEW_ENV = "blue"
                        NEW_CONTAINER = env.BLUE_CONTAINER
                        OLD_CONTAINER = env.GREEN_CONTAINER
                    }

                    env.NEW_ENV = NEW_ENV
                    env.NEW_CONTAINER = NEW_CONTAINER
                    env.OLD_CONTAINER = OLD_CONTAINER

                    echo "Active: ${ACTIVE}"
                    echo "Deploying to: ${NEW_ENV}"
                }
            }
        }

        stage('Deploy to Inactive Environment') {
            steps {
                sh """
                docker stop ${NEW_CONTAINER} || true
                docker rm ${NEW_CONTAINER} || true
                docker run -d --name ${NEW_CONTAINER} ${IMAGE_NAME}
                """
            }
        }
        stage('Switch Traffic') {
            steps {
                sh """
                # Kill anything using port 9090
                docker ps -q --filter "publish=9090" | xargs -r docker rm -f
        
                # Remove old active container
                docker rm -f ${OLD_CONTAINER} || true
        
                # Restart new container with port binding
                docker rm -f ${NEW_CONTAINER} || true
                docker run -d -p 9090:80 --name ${NEW_CONTAINER} ${IMAGE_NAME}
        
                echo ${NEW_ENV} > ${ACTIVE_FILE}
                """
            }
        }

    }
}
