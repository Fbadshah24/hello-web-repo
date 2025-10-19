#!/usr/bin/env bash
set -euo pipefail

# Inputs from Jenkins
AWS_ACCESS_KEY_ID="$1"
AWS_SECRET_ACCESS_KEY="$2"
AWS_DEFAULT_REGION="$3"
ECR_REPO="$4"     # full repo URI e.g. 123456789012.dkr.ecr.us-east-1.amazonaws.com/hello-web-repo
IMAGE_TAG="$5"    # e.g. git short sha

if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_DEFAULT_REGION" ] || [ -z "$ECR_REPO" ] || [ -z "$IMAGE_TAG" ]; then
  echo "Usage: $0 <aws_access_key> <aws_secret_key> <region> <ecr_repo> <image_tag>"
  exit 2
fi

# Export AWS credentials for AWS CLI
export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION

echo "🔹 Authenticating with AWS ECR..."
aws sts get-caller-identity >/dev/null

# ECR login
aws ecr get-login-password --region "$AWS_DEFAULT_REGION" | docker login --username AWS --password-stdin "$(echo "$ECR_REPO" | cut -d'/' -f1)"

# Prepare build context
BUILD_DIR=$(mktemp -d)
cp ../app/index.html "$BUILD_DIR/"
cp ../docker/nginx.conf "$BUILD_DIR/"
cp ../docker/Dockerfile "$BUILD_DIR/"
cd "$BUILD_DIR"

# Build and push image
echo "🔹 Building Docker image..."
docker build -t "${ECR_REPO}:${IMAGE_TAG}" .

echo "🔹 Pushing Docker image to ECR..."
docker push "${ECR_REPO}:${IMAGE_TAG}"

echo "✅ Pushed ${ECR_REPO}:${IMAGE_TAG} successfully."
