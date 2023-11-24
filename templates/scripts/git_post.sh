#!/bin/bash -x
# Accept Command Line Arguments
GITHUB_TOKEN=$1
PR_NUMBER=$2

# Read the content of the text file
COMMENT=$(<terraform_plan_output.txt)

COMMENT=$(echo "$COMMENT" | jq -s -R '.' | sed 's/^"\(.*\)"$/\1/')

curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"body": "'"$COMMENT"'"}' \
  "https://api.github.com/repos/rakeshpb90/terraform-demo/issues/$PR_NUMBER/comments" \
  -sS