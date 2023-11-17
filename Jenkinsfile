pipeline {
    agent any
    environment {
        PORT = "8000"
    }
    stages {
        stage('Build') {
            steps {
                sh '''
                docker build -t jasonatkins/lbg:${BUILD_NUMBER} --build-arg PORT=${PORT} .
                docker tag jasonatkins/lbg:${BUILD_NUMBER} jasonatkins/lbg:latest
                docker build -t jasonatkins/lbg-nginx nginx
                '''
           }
        }
        stage('Push') {
            steps {
                sh '''
                docker push jasonatkins/lbg:${BUILD_NUMBER}
                docker push jasonatkins/lbg-nginx
                docker rmi jasonatkins/lbg:${BUILD_NUMBER}
                docker rmi jasonatkins/nginx
                '''
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                    ssh jenkins@jason-deploy-2 <<EOF
                    export PORT=${PORT}
                    export VERSION=${BUILD_NUMBER}
                    docker network inspect lbg-net && echo "network exists" || docker network create lbg-net
                    docker pull jasonatkins/lbg
                    docker pull jasonatkins/lbg-nginx
                    docker stop lbg-nginx && echo "Stopped lbg-nginx" || echo "lbg-nginx is not running"
                    docker rm lbg-nginx && echo "removed lbg-nginx" || echo "lbg-nginx does not exist"
                    docker stop lbg-app && echo "Stopped lbg-app" || echo "lbg-app is not running"
                    docker rm lbg-app && echo "removed lbg-app" || echo "lbg-app does not exist"
                    docker run -d  --name lbg-app --network lbg-net jasonatkins/lbg:${VERSION}
                    docker run -d  --name lbg-nginx -p 80:${PORT} --network lbg-net  jasonatkins/lbg-nginx
                '''
            }
        }
    }
}
