terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.12.1"
    }
  }

    backend "s3" {
        bucket         = "terraformstateec2"
        key            = "dev/terraform.tfstate"      
        region         = "us-east-1"             
        encrypt        = true
        dynamodb_table = "tf-state-lock-dynamo"   
    }
}