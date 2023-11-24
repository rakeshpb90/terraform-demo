#!/bin/bash -x 
# Accept Command Line Arguments
GITHUB_TOKEN=$1
PR_NUMBER=$2
COMMENT=$(cat terraform_plan_output.json)
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"body\": \"$COMMENT\"}" \
  "https://api.github.com/repos/rakeshpb90/terraform-demo/issues/$PR_NUMBER/comments"


  