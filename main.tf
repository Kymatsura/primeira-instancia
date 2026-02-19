terraform {
 required_providers {
  aws = {
   source = "hashicorp/aws"
   version = "~> 5.0"
   }
 }
}

provider "aws" {
 region = "us-east-2"
}

data "aws_ami" "amazon_linux" {
 most_recent = true
 owners      = ["amazon"]

filter {
 name = "name"
 values = ["amzn2-ami-hvm-*-x86_64-gp2"]
 }
}

output "ami_id" {
 value = data.aws_ami.amazon_linux.id
}
