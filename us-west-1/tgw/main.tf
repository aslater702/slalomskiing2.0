# Create transit gateway primary
resource "aws_ec2_transit_gateway" "primarytransitgateway" {
  provider = aws.primary
  description = "Transit Gateway primary region"
}
resource "aws_ec2_transit_gateway" "secondarytransitgateway" {
  provider = aws.peer
  description = "Transit Gateway secondary region"
}
# Connect transit gateway to subnets and vpc
# , var.private2_subnet_id, var.private3_subnet_id
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
# One time request to peer two VPCs using transit gateway
provider "aws" {
  alias  = "primary"
  region = "us-west-1"
}

provider "aws" {
  alias  = "peer"
  region = "eu-west-1"
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
# creating transit gateway route table
resource "aws_ec2_transit_gateway_route_table" "tgwroutetable" {
  transit_gateway_id = aws_ec2_transit_gateway.primarytransitgateway.id
}
# associate primary tgw with route table above
resource "aws_ec2_transit_gateway_route_table_association" "tgwassociation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgwroutetable.id
}