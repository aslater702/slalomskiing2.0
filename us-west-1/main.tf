# main directory
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  # alias  = "local"
  region = "us-east-1"
}

module "vpc" {
  source = "./vpc"
  # transit_gateway_id = module.tgw.transit_gateway_id
}

module "tgw" {
  source = "./tgw"
  aws_region = "us-east-1"
  vpc_id = module.vpc.vpc_id
  private1_subnet_id = module.vpc.private1_subnet_id
  private2_subnet_id = module.vpc.private2_subnet_id
  private3_subnet_id = module.vpc.private3_subnet_id
  private_route_table = module.vpc.private_route_table
  auto_accept_shared_attachments                  = "enable"
  amazon_side_asn                                 = "64512"
}