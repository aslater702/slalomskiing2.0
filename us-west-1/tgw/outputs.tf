# output transit gateway ID for private route table 1
output "transit_gateway_id" {
  value       = aws_ec2_transit_gateway.primarytransitgateway.id
  description = "ID of the TGW in the primary region"
}