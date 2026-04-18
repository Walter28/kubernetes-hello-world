pipeline {
    agent any

    tools {
        dockerTool 'docker-cli'
    }
    
    environment {
        DOCKER_REGISTRY = 'host.docker.internal:5005'  // Change to your registry
        BACKEND_IMAGE = 'hello-world-backend'
        FRONTEND_IMAGE = 'hello-world-frontend'
        IMAGE_TAG = "1.0.${BUILD_NUMBER}"
        KUBECONFIG = credentials('kubeconfig-local')
    }
    
    stages {
        // “Utilise la config SCM déjà définie dans Jenkins”
        // SCM -> Source Control Management
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Fix Permissions') {
            steps {
                // Cette commande tente de forcer l'accès au socket avant de builder
                sh "sudo chmod 666 /var/run/docker.sock || true" 
            }
        }
        
        stage('Build Backend Image') {
            steps {
                script {
                    dir('server') {
                        sh "docker build -t ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} ."
                        sh "docker tag ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:latest"
                    }
                }
            }
        }
        
        stage('Build Frontend Image') {
            steps {
                script {
                    dir('client') {
                        sh "docker build -t ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG} ."
                        sh "docker tag ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG} ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:latest"
                    }
                }
            }
        }
        
        stage('Push Images') {
            steps {
                script {
                    // Push backend images
                    sh "docker push ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG}"
                    sh "docker push ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:latest"
                    
                    // Push frontend images
                    sh "docker push ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG}"
                    sh "docker push ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:latest"
                }
            }
        }

        stage('Setup Kubectl') {
            steps {
                script {
                    sh 'curl -LO "https://k8s.io(curl -L -s https://k8s.io)/bin/linux/amd64/kubectl"'
                    sh 'chmod +x ./kubectl'
                    // Use ./kubectl to run commands
                    sh './kubectl get pods'
                }
            }
        }
        
        stage('Update Kubernetes Deployments') {
            steps {
                script {
                    // Update backend deployment
                    sh """
                    sed -i 's|image: .*|image: ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG}|' k8s/backend-deployment.yaml
                    """
                    
                    // Update frontend deployment
                    sh """
                    sed -i 's|image: .*|image: ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG}|' k8s/frontend-deployment.yaml
                    """
                    
                    // Apply updated deployments
                    withKubeConfig([credentialsId: 'kubeconfig-local']) {
                        sh './kubectl apply -f k8s/'
                    }
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    withKubeConfig([credentialsId: 'kubeconfig-local']) {
                        // Wait for deployments to roll out
                        sh './kubectl rollout status deployment/backend-deployment --timeout=300s'
                        sh './kubectl rollout status deployment/frontend-deployment --timeout=300s'
                        
                        // Check pod status
                        sh './kubectl get pods -l component=backend'
                        sh './kubectl get pods -l component=frontend'
                        
                        // Check services
                        sh './kubectl get services'
                    }
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                script {
                    // Clean up local images to save space
                    sh "docker rmi ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} || true"
                    sh "docker rmi ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG} || true"
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
            echo "Images deployed with tag: ${IMAGE_TAG}"
        }
        
        failure {
            echo 'Pipeline failed!'
            // mail to: 'devops@example.com',
            //      subject: "Jenkins Pipeline Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
            //      body: "The pipeline failed at build ${env.BUILD_NUMBER}. Please check the logs."
        }
        
        always {
            // Clean up workspace
            cleanWs()
        }
    }
}
