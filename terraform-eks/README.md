# AWS EKS Cluster with Nginx, Prometheus, and Grafana

This Terraform configuration creates an AWS EKS cluster with the following components:
- EKS cluster with managed node groups
- VPC with public and private subnets
- Nginx deployment with service and ingress
- Prometheus and Grafana monitoring stack
- Nginx Ingress Controller

## Prerequisites

1. AWS CLI configured with appropriate credentials
2. Terraform installed (version >= 1.2.0)
3. kubectl installed
4. Helm installed

## Setup Instructions

1. Initialize Terraform:
```bash
terraform init
```

2. Review the planned changes:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform apply
```

4. After the cluster is created, update your kubeconfig:
```bash
aws eks --region <region> update-kubeconfig --name <cluster-name>
```

5. Verify the cluster access:
```bash
kubectl get nodes
```

## Accessing the Applications

### Nginx
- The Nginx service will be accessible through the ingress controller
- Update your hosts file with the ingress hostname and the LoadBalancer IP

### Grafana
- Access Grafana through the ingress controller
- Default credentials:
  - Username: admin
  - Password: prom-operator

### Prometheus
- Access Prometheus through the ingress controller
- The service is configured to scrape metrics from the Nginx deployment

## Monitoring

The configuration includes:
- Prometheus for metrics collection
- Grafana for visualization
- ServiceMonitor for Nginx metrics
- Pre-configured dashboards for Kubernetes and Nginx monitoring

## Cleanup

To destroy all created resources:
```bash
terraform destroy
```

## Notes

- The configuration uses t3.medium instances by default
- The cluster is configured with public access enabled
- All necessary security groups and IAM roles are created automatically
- The monitoring stack is installed in the 'monitoring' namespace
- Nginx ingress controller is installed in the 'ingress-nginx' namespace 