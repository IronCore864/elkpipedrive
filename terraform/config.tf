terraform {
  required_version = ">= 0.14.7"

  required_providers {
    aws = {
      version = ">= 3.20"
      source  = "hashicorp/aws"
    }
  }

  # For produciton purpose, remote backend with state lock is desired.
  # This local state is only for testing

  # backend "s3" {
  #   bucket         = "tf-state-xxx"
  #   key            = "terraform.tfstate"
  #   region         = "eu-central-1"
  #   encrypt        = true
  #   dynamodb_table = "tf_state_lock_yyy"
  # }
}

provider "aws" {
  region = "eu-central-1"
  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
}
