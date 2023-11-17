pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh '''
                docker build -t jasonatkins/lbg .
                docker build -t jasonatkins/lbg-nginx nginx
                '''
           }
        }
        stage('Push') {
            steps {
                sh '''
                docker push jasonatkins/lbg
                docker push jasonatkins/lbg-nginx
                '''
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                    ssh jenkins@jason-deploy-2 <<EOF
                    docker pull jasonatkins/lbg
                    docker pull jasonatkins/lbg-nginx
                    docker stop lbg-nginx && echo "Stopped lbg-nginx" || echo "lbg-nginx is not running"
                    docker rm lbg-nginx && echo "removed lbg-nginx" || echo "lbg-nginx does not exist"
                    docker stop lbg-app && echo "Stopped lbg-app" || echo "lbg-app is not running"
                    docker rm lbg-app && echo "removed lbg-app" || echo "lbg-app does not exist"
                    docker run -d  --name lbg-app jasonatkins/lbg
                    docker run -d  --name lbg-nginx -p 80:80 jasonatkins/lbg-nginx
                '''
            }
        }
    }
}
