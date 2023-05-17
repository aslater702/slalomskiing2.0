# AWS Region Primary
variable "aws_region" {
	default = "us-east-1"
}
# AMI variable for app servers
variable "AMI" {
    type = map(string)
    default = {
        eu-west-1 = "ami-08ca3fed11864d6bb" # Ubuntu 20.04 x86 THIS NEEDS TO CHANGE REGIONS
    }
}
# will need to create a public key, placeholder for now
variable "PUBLIC_KEY_PATH" {
    default = "~/.ssh/id_rsa.pub" # Replace with a path to public key
}
# Defining S3 bucket name for static website hosting
variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  default     = "terraform-state-my-bucket"
}
# Defining CIDR Block for VPC
variable "vpc_cidr" {
  default = "10.1.0.0/20"
}
# Used visual subnet calculator to define subnets that are right sized for IP space
# Defining CIDR Block for 1st Public Subnet
variable "publicsubnet1_cidr" {
  default = "10.1.0.0/23"
}
# Defining CIDR Block for 2nd Public Subnet
variable "publicsubnet2_cidr" {
  default = "10.1.2.0/23"
}
# Defining CIDR Block for 3rd Public Subnet
variable "publicsubnet3_cidr" {
  default = "10.1.4.0/23"
}
# Defining CIDR Block for 1st Private Subnet
variable "privatesubnet1_cidr" {
  default = "10.1.6.0/23"
}
# Defining CIDR Block for 2nd Private Subnet
variable "privatesubnet2_cidr" {
  default = "10.1.8.0/22"
}
# Defining CIDR Block for 3rd Private Subnet
variable "privatesubnet3_cidr" {
  default = "10.1.12.0/22"
}
# transit gateway ID
variable "transit_gateway_id" {
  default = []
}