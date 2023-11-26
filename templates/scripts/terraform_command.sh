#!/bin/bash -x
# Accept Command Line Arguments
GITHUB_TOKEN=$1
PR_NUMBER=$2

echo "## INIT: Terraform Initialization ..."
terraform init
if [ $? -eq 0 ]; then
    tfInitOutput="SUCCESS"
else
    tfInitOutput="FAIL"
fi


echo "## FORMATTING: Formatting Terraform code ..."
terraform fmt -check
if [ $? -eq 0 ]; then
    tfFormatOutput="SUCCESS"
else
    tfFormatOutput="FAIL"
fi

echo "## VALIDATION: Validating Terraform code ..."
terraform validate
if [ $? -eq 0 ]; then
    tfValidateOutput="SUCCESS"
else
    tfValidateOutput="FAIL"
fi

echo "## PLAN: Generate the Terraform Plan"
terraform plan -var-file=dev.tfvars -out tfapply
if [ $? -eq 0 ]; then
    tfPlanOutput="SUCCESS"
else
    tfPlanOutput="FAIL"
fi

terraform show tfapply -no-color > terraform_plan_output.txt


# Read the content of the text file
FILE_OUTPUT=$(<terraform_plan_output.txt)

# Escape special characters in the text for JSON
OUTPUT=$(echo "$FILE_OUTPUT" | grep -v "Refreshing state" | tail -c 60000| jq -s -R '.' | sed 's/^"\(.*\)"$/\1/')



# Format the comment as specified
COMMENT="#### Terraform Format and Style 🖌 ${tfFormatOutput}\n#### Terraform Initialization ⚙️ ${tfInitOutput}\n#### Terraform Validation 🤖 ${tfValidateOutput}\n#### Terraform Plan 📖  ${tfPlanOutput}<details><summary>Show Plan</summary>\n\n\`\`\`hcl\n$OUTPUT\n\`\`\`\n\n</details>"

# Post the comment to the pull request
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"body\": \"$COMMENT\"}" \
  "https://api.github.com/repos/rakeshpb90/terraform-demo/issues/$PR_NUMBER/comments" \
  -sS

