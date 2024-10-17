#!/bin/bash
#/var/lib/tom
TARGET_DIR="/home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics/"

if [ -d "$TARGET_DIR" ]; then
  if [ -r "$TARGET_DIR" ] && [ -x "$TARGET_DIR" ]; then
    cd "$TARGET_DIR" || { echo "Failed to change directory"; exit 1; }
    echo "Successfully changed directory to $TARGET_DIR"
  else
    echo "Permission denied for $TARGET_DIR"
    exit 1
  fi
else
  echo "Directory $TARGET_DIR does not exist."
  exit 1
fi

timestamp=$(date +"%d_%m_%Y_%H_%M")
echo "Wait , Docker Build Is in Progess at $timestamp"

docker build -t 628928421814.dkr.ecr.us-west-1.amazonaws.com/byoa:pzeonapp-angular17-v$timestamp . --no-cache
export AWS_PROFILE=hub
echo "Docker Build Is Now Fire Successfully"
docker login -u AWS -p $(aws ecr get-login-password --region us-west-1) 628928421814.dkr.ecr.us-west-1.amazonaws.com
echo "Start pushing images to AWS"
docker push 628928421814.dkr.ecr.us-west-1.amazonaws.com/byoa:pzeonapp-angular17-v$timestamp
latestimg=$(aws ecr describe-images --repository-name byoa --region us-west-1 --query 'sort_by(imageDetails,&imagePushedAt)[-1].imageTags[0]')
echo 628928421814.dkr.ecr.us-west-1.amazonaws.com/byoa:$latestimg
