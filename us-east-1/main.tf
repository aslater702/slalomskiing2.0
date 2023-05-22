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
}

module "tgw" {
  source = "./tgw"
  vpc_id = module.vpc.vpc_id
  private1_subnet_id = module.vpc.private1_subnet_id
  private2_subnet_id = module.vpc.private2_subnet_id
  private3_subnet_id = module.vpc.private3_subnet_id
  private_route_table = module.vpc.private_route_table
  auto_accept_shared_attachments = "enable"
  amazon_side_asn = "64512"
}

module "s3" {
  source = "./s3"
}

module "cloudfront" {
  source = "./cloudfront"
  s3_domain = module.s3.s3_domain
  # from eu-west-1 region
  failover_bucket_domain = var.failover_bucket_domain
  cloudfront_origin = module.s3.cloudfront_origin
  depends_on = module.s3
}