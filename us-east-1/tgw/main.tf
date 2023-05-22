# One time request to peer two VPCs using transit gateway
provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

provider "aws" {
  alias  = "peer"
  region = "eu-west-1"
}
# Create transit gateway primary
resource "aws_ec2_transit_gateway" "primarytransitgateway" {
  provider = aws.primary
  auto_accept_shared_attachments   = var.auto_accept_shared_attachments
  amazon_side_asn                  = var.amazon_side_asn
  description = "Transit Gateway us-west-1"
  tags = {
    Name = "us-east-1 tgw"
  }

}
resource "aws_ec2_transit_gateway" "secondarytransitgateway" {
  provider = aws.peer
  description = "Transit Gateway eu-west-1"
}
# Connect transit gateway to subnets and vpc
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  subnet_ids         = [
    var.private1_subnet_id, 
    var.private2_subnet_id, 
    var.private3_subnet_id
    ]
  transit_gateway_id = aws_ec2_transit_gateway.primarytransitgateway.id
  vpc_id             = var.vpc_id
}
resource "aws_ec2_transit_gateway_connect" "tgw_connect" {
  transport_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment.id
  transit_gateway_id      = aws_ec2_transit_gateway.primarytransitgateway.id
}

data "aws_region" "peer" {
  provider = aws.peer
}

resource "aws_ec2_transit_gateway_peering_attachment" "one_time__tgw_attachment" {
  peer_account_id         = aws_ec2_transit_gateway.secondarytransitgateway.owner_id
  peer_region             = data.aws_region.peer.name
  peer_transit_gateway_id = aws_ec2_transit_gateway.secondarytransitgateway.id
  transit_gateway_id      = aws_ec2_transit_gateway.primarytransitgateway.id

  tags = {
    Name = "TGW Peering Requestor"
  }
}
# Add TGW to existing private route table
resource "aws_route" "add_tgw_route" {
  route_table_id         = var.private_route_table
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.primarytransitgateway.id
}