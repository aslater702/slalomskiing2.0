output "vpc_id" {
    value = aws_vpc.vpc1.id
}
output "private1_subnet_id" {
    value = aws_subnet.private1_subnet.id
}
output "private2_subnet_id" {
    value = aws_subnet.private2_subnet.id
}
output "private3_subnet_id" {
    value = aws_subnet.private3_subnet.id
}
output "private_route_table" {
    value = aws_route_table.rt_privateprimary.id
}
output "vpc_tag" {
    value = aws_vpc.vpc1.tags
}