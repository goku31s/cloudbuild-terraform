pipeline {
    agent any

    environment {
        PROJECT_ID = 'sukrit-singh-426716'
        CLUSTER_NAME = 'my-gke-cluster'
        LOCATION = 'us-east1'
        CREDENTIALS_ID = 'gcp-credentials'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and Push Image') {
            steps {
                script {
                    def imageTag = "us-central1-docker.pkg.dev/${PROJECT_ID}/my-repo/image:v${env.BUILD_NUMBER}"
                    withCredentials([file(credentialsId: 'gcp-credentials', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh "docker build -t ${imageTag} ./tasktfcloudbuild"
                        sh "docker push ${imageTag}"
                    }
                }
            }
        }

        stage('Update Kubernetes Manifests') {
            steps {
                script {
                    sh "sed -i 's|image: .*|image: us-central1-docker.pkg.dev/${PROJECT_ID}/my-repo/image:v${env.BUILD_NUMBER}|' k8s/*.yaml"
                }
            }
        }

        stage('Deploy to GKE') {
            steps {
                step([$class: 'KubernetesEngineBuilder', 
                      projectId: env.PROJECT_ID, 
                      clusterName: env.CLUSTER_NAME, 
                      location: env.LOCATION, 
                      manifestPattern: 'k8s/*.yaml', 
                      credentialsId: env.CREDENTIALS_ID, 
                      verifyDeployments: true])
            }
        }
    }
}
