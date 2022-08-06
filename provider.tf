terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}

# Jakarta Region
provider "aws" {
    region = "ap-southeast-3"
}