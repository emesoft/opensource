terraform {
  backend "s3" {
    bucket     = "my-tofu-state"
    key        = "state.tfstate"
    region     = "ap-southeast-1"
  }

  encryption {

    key_provider "aws_kms" "tf-state-key" {
      kms_key_id = "0ec6d824-a0c3-4dc1-8267-b10e3cd44ed2"
      region     = "ap-southeast-1"
      key_spec   = "AES_256"
    }

    method "aes_gcm" "encryp-aes" {
      keys = key_provider.aws_kms.tf-state-key
    }
    state {
      method = method.aes_gcm.encryp-aes
    }
  }
}



# Configure the AWS provider
provider "aws" {
  region = "ap-southeast-1"
}

# Create an S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "my-example-tofu"
}
