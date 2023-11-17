pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh '''
                docker build -t jasonatkins/lbg .
                '''
           }
        }
        stage('Push') {
            steps {
                sh '''
                docker push jasonatkins/lbg
                '''
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                    ssh jenkins@jason-deploy-2 <<EOF
                    docker pull jasonatkins/lbg
                    docker stop lbg-app && echo "Stopped lbg-app" || echo "lbg-app is not running"
                    docker rm lbg-app && echo "removed lbg-app" || echo "lbg-app does not exist"
                    docker run -d  --name lbg-app -p 80:8080 jasonatkins/lbg
                '''
            }
        }
    }
}
