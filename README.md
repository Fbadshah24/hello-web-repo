# hello-eks-deployment

Automated deployment of a simple Nginx "Hello World" web app to AWS EKS using Terraform and Jenkins.

## Overview
- **Region:** us-east-1
- **EKS node type:** t3.micro
- **Node count:** 2
- **Registry:** AWS ECR
- **CI/CD:** Jenkins

## Repo layout
```
{
  'app/': ['index.html'],
  'docker/': ['Dockerfile','nginx.conf'],
  'k8s/': ['deployment.yaml','service.yaml'],
  'jenkins/': ['Jenkinsfile','scripts/aws-ecr-login-and-push.sh'],
  'terraform/': ['main.tf','variables.tf','outputs.tf'],
  'README.md'
}
```

## Quick start (high-level)

### Prerequisites
- Terraform >= 1.2
- AWS CLI configured with credentials that can create EKS, VPC, ECR, IAM, EC2
- kubectl
- Docker (for build)
- Jenkins with Docker capability (or a Jenkins agent with Docker)

### 1. Create infra with Terraform
```bash
cd terraform
terraform init
terraform apply -var 'aws_region=us-east-1'
```

Outputs include the ECR repo URI and cluster details.

### 2. Configure kubectl locally
```bash
aws eks update-kubeconfig --region us-east-1 --name hello-eks-cluster
kubectl get nodes
```

### 3. Configure Jenkins
- Create a Jenkins pipeline job using the provided `Jenkinsfile`.
- Add credentials:
  - `kubeconfig-file`: secret file credential containing a kubeconfig for the cluster
  - AWS credentials available to Jenkins (or use an IAM role)
- Set `ECR_REPO` environment variable in Jenkins (use Terraform output `ecr_repo_uri`)

### 4. Push pipeline changes
Push to `main` to trigger your configured webhook and run the pipeline.

## Notes & security
- Do not commit any AWS secret keys to the repo.
- Prefer IRSA / IAM roles for Jenkins agents where possible.
- For production, consider using ALB Ingress + cert-manager for TLS.
