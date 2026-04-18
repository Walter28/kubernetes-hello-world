#!/bin/bash

# Deployment script for local development
# This script builds images and deploys to local Kubernetes

set -e

# Configuration
DOCKER_REGISTRY="localhost:5000"
BACKEND_IMAGE="hello-world-backend"
FRONTEND_IMAGE="hello-world-frontend"
IMAGE_TAG="1.0.0"

echo "Starting deployment process..."

# Build backend image
echo "Building backend image..."
cd server
docker build -t ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} .
docker tag ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG} ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:latest
cd ..

# Build frontend image
echo "Building frontend image..."
cd client
docker build -t ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG} .
docker tag ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG} ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:latest
cd ..

# Push to local registry (if running)
if docker ps | grep -q "registry:2"; then
    echo "Pushing images to local registry..."
    docker push ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG}
    docker push ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:latest
    docker push ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG}
    docker push ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:latest
else
    echo "Local registry not found, using local images..."
fi

# Update Kubernetes manifests
echo "Updating Kubernetes manifests..."
sed -i.bak "s|image: .*|image: ${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${IMAGE_TAG}|g" k8s/backend-deployment.yaml
sed -i.bak "s|image: .*|image: ${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${IMAGE_TAG}|g" k8s/frontend-deployment.yaml

# Apply to Kubernetes
echo "Applying to Kubernetes..."
kubectl apply -f k8s/

# Wait for deployments
echo "Waiting for deployments to be ready..."
kubectl rollout status deployment/backend-deployment --timeout=300s
kubectl rollout status deployment/frontend-deployment --timeout=300s

# Show status
echo "Deployment status:"
kubectl get pods -l component=backend
kubectl get pods -l component=frontend
kubectl get services
kubectl get ingress

echo "Deployment completed successfully!"
echo "Access the application at: http://localhost"
