pipeline {
    agent any
    environment {
        GCR_CREDENTIALS_ID = "JenkinsGCRKeyId"
        IMAGE_NAME = "lbg-python-api-base-image-from-jenkins"
        GCR_URL = "gcr.io/lbg-mea-15"
        PROJECT_ID="lbg-mea-15"
        CLUSTER_NAME="jason-cluster"
        LOCATION="europe-west2-c"
        CREDENTIALS_ID="37200621-893f-4618-82c4-58eac17b3994"
    }
    stages {
        stage('Build and Push to GCR')
        {
            steps
            {
                script
                {
                    //Authenticate with Google Cloud
                    withCredentials([file(credentialsId:GCR_CREDENTIALS_ID, variable:'GOOGLE_APPLICATION_CREDENTIALS')])
                    {
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                    }

                    // Configure Docker to use gcloud as a credential helper
                    sh 'gcloud auth configure-docker --quiet'

                    // Build the Docker image
                    sh 'docker build -t ${GCR_URL}/${IMAGE_NAME}:${BUILD_NUMBER} .'

                    // Push the Docker image to GCR
                    sh 'docker push ${GCR_URL}/${IMAGE_NAME}:${BUILD_NUMBER}'
                }

            }
        }

        stage('Deploy to GKE staging')
        {
            steps{
                script{
                       // Deploy to GKE using Jenkins Kubernetes Engine Plugin
                      step([
                      $class: 'KubernetesEngineBuilder', 
                      projectId: env.PROJECT_ID, 
                      clusterName: env.CLUSTER_NAME, 
                      location: env.LOCATION, 
                      manifestPattern: 'kubernetes/deployment.yaml', 
                      credentialsId: env.CREDENTIALS_ID, 
                      verifyDeployments: true,
                      namespace: "staging"]
                      ) 
                }
            }
        }
                stage('Deploy to GKE prodution')
        {
            steps{
                script{
                       // Deploy to GKE using Jenkins Kubernetes Engine Plugin
                      step([
                      $class: 'KubernetesEngineBuilder', 
                      projectId: env.PROJECT_ID, 
                      clusterName: env.CLUSTER_NAME, 
                      location: env.LOCATION, 
                      manifestPattern: 'kubernetes/deployment.yaml', 
                      credentialsId: env.CREDENTIALS_ID, 
                      verifyDeployments: true,
                      namespace: "production"]
                      ) 
                }
            }
        }

    }
}
