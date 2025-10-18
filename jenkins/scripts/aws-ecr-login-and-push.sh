#!/usr/bin/env bash
set -euo pipefail

ECR_REPO="$1"    # full repo URI e.g. 123456789012.dkr.ecr.us-east-1.amazonaws.com/hello-web-repo
IMAGE_TAG="$2"    # e.g. git short sha

if [ -z "$ECR_REPO" ] || [ -z "$IMAGE_TAG" ]; then
  echo "Usage: $0 <ecr_repo> <image_tag>"
  exit 2
fi

# Ensure AWS CLI is configured in the environment where this runs.
aws sts get-caller-identity >/dev/null

# login
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$(echo "$ECR_REPO" | cut -d'/' -f1)"

# prepare build context
BUILD_DIR=$(mktemp -d)
cp ../app/index.html "$BUILD_DIR/"
cp ../docker/nginx.conf "$BUILD_DIR/"
cp ../docker/Dockerfile "$BUILD_DIR/"
cd "$BUILD_DIR"

docker build -t "${ECR_REPO}:${IMAGE_TAG}" .
docker push "${ECR_REPO}:${IMAGE_TAG}"

echo "Pushed ${ECR_REPO}:${IMAGE_TAG}"
