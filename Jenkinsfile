
pipeline {
    agent any
    
    environment {
        PROJECT_ID = 'sukrit-singh-426716'
        CLUSTER_NAME = 'my-gke-cluster'
        LOCATION = 'us-east1'
        ARTIFACT_REGISTRY = 'us-central1-docker.pkg.dev'
        REPOSITORY = 'my-repo'
        IMAGE_NAME = 'nginx-app'
        CREDENTIALS_ID = 'gcp-credentials'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    app = docker.build("${ARTIFACT_REGISTRY}/${PROJECT_ID}/${REPOSITORY}/${IMAGE_NAME}:${env.BUILD_NUMBER}")
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry("https://${ARTIFACT_REGISTRY}", "gcr:${CREDENTIALS_ID}") {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        
        stage('Deploy to GKE') {
            steps {
                sh "gcloud container clusters get-credentials ${CLUSTER_NAME} --location ${LOCATION} --project ${PROJECT_ID}"
                sh "kubectl apply -f kubernetes.yaml"
                sh "kubectl set image deployment/nginx-deployment nginx=${ARTIFACT_REGISTRY}/${PROJECT_ID}/${REPOSITORY}/${IMAGE_NAME}:${env.BUILD_NUMBER}"
            }
        }
    }
}
