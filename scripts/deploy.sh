#!/bin/bash
echo "Building Docker images..."
docker build -f microservices/Dockerfiles/service-a.Dockerfile -t service-a:latest microservices/service-a

echo "Pushing to ECR (optional)..."
# aws ecr get-login-password | docker login ...

echo "Applying Terraform..."
cd infra && terraform init && terraform apply -auto-approve

echo "Deploying to EKS..."
kubectl apply -f k8s/
