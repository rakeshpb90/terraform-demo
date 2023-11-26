#!/bin/bash -x
# Accept Command Line Arguments
GITHUB_TOKEN=$1
PR_NUMBER=$2

# Read the content of the text file
FILE_OUTPUT=$(<terraform_plan_output.txt)

# Escape special characters in the text for JSON
OUTPUT=$(echo "$FILE_OUTPUT" | jq -s -R '.' | sed 's/^"\(.*\)"$/\1/')

# Format the comment as specified
COMMENT="#### Terraform Format and Style 🖌\n#### Terraform Initialization ⚙️\n#### Terraform Validation 🤖\n#### Terraform Plan 📖 <details><summary>Show Plan</summary>\n\n\`\`\`hcl\n$OUTPUT\n\`\`\`\n\n</details>"

# Post the comment to the pull request
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"body\": \"$COMMENT\"}" \
  "https://api.github.com/repos/rakeshpb90/terraform-demo/issues/$PR_NUMBER/comments" \
  -sS

