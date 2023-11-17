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
                    docker stop lbg && echo "Stopped lbg" || echo "lbg is not running"
                    docker rm lbg && echo "removed lbg" || echo "lbg does not exist"
                    docker run -d  --name lbg-app -p 80:80 jasonatkins/lbg
                '''
            }
        }
    }
}
