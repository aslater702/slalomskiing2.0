# primary region vpc
resource "aws_vpc" "vpc1" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "primary VPC"
  }
}
################################### SUBNETS #############################################
# Creating public subnets
resource "aws_subnet" "public1_subnet" {
  vpc_id                  = "${aws_vpc.vpc1.id}"
  cidr_block             = "${var.publicsubnet1_cidr}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
tags = {
    Name = "primary public subnet 1"
  }
}
resource "aws_subnet" "public2_subnet" {
  vpc_id                  = "${aws_vpc.vpc1.id}"
  cidr_block             = "${var.publicsubnet2_cidr}"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
tags = {
    Name = "primary public subnet 2"
  }
}
resource "aws_subnet" "public3_subnet" {
  vpc_id                  = "${aws_vpc.vpc1.id}"
  cidr_block             = "${var.publicsubnet3_cidr}"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
tags = {
    Name = "primary public subnet 3"
  }
}
# Create private subnets
resource "aws_subnet" "private1_subnet" {
  vpc_id                  = "${aws_vpc.vpc1.id}"
  cidr_block             = "${var.privatesubnet1_cidr}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
tags = {
    Name = "primary private subnet 1"
  }
}
resource "aws_subnet" "private2_subnet" {
  vpc_id                  = "${aws_vpc.vpc1.id}"
  cidr_block             = "${var.privatesubnet2_cidr}"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false
tags = {
    Name = "primary private subnet 2"
  }
}
resource "aws_subnet" "private3_subnet" {
  vpc_id                  = "${aws_vpc.vpc1.id}"
  cidr_block             = "${var.privatesubnet3_cidr}"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = false
tags = {
    Name = "primary private subnet 3"
  }
}
################################### NETWORK ACLS ###########################################
# Create network ACLs for public subnets
resource "aws_network_acl" "publicnacl" {
  vpc_id = aws_vpc.vpc1.id
  subnet_ids = [aws_subnet.public1_subnet.id, aws_subnet.public2_subnet.id, aws_subnet.public3_subnet.id]
  # outbound traffic
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0" # may also need to include failover VPC CIDR range
    from_port  = 443
    to_port    = 443
  }

  # inbound traffic
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0" 
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "public ACL"
  }
}
# Create network ACLs for private subnets
resource "aws_network_acl" "privatenacl" {
  vpc_id = aws_vpc.vpc1.id
  subnet_ids = [aws_subnet.private1_subnet.id, aws_subnet.private2_subnet.id, aws_subnet.private3_subnet.id]

  # outbound traffic
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.1.0.0/20" # may also need to include failover VPC CIDR range
    from_port  = 443
    to_port    = 443
  }

  # inbound traffic
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.1.0.0/20" 
    from_port  = 80 # can private subnets use port 80?
    to_port    = 80
  }

  tags = {
    Name = "private ACL"
  }
}
################################### ROUTE TABLES ###########################################
# Creating Internet Gateway 
resource "aws_internet_gateway" "internetgateway_1" {
  vpc_id = "${aws_vpc.vpc1.id}"
  tags = {
        Name = "SS Internet Gateway"
    }
}
# Creating Route Table for Public Subnets
resource "aws_route_table" "rt_publicprimary" {
    vpc_id = aws_vpc.vpc1.id
    route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.internetgateway_1.id
        }
    tags = {
            Name = "PublicRouteTable us-east-1"
        }
}
# Associate public subnet 1 with route table
resource "aws_route_table_association" "rt_associate_public1" {
    subnet_id = aws_subnet.public1_subnet.id
    route_table_id = aws_route_table.rt_publicprimary.id
}
# Associate public subnet 2 with route table
resource "aws_route_table_association" "rt_associate_public2" {
    subnet_id = aws_subnet.public2_subnet.id
    route_table_id = aws_route_table.rt_publicprimary.id
}
# Associate public subnet 3 with route table
resource "aws_route_table_association" "rt_associate_public3" {
    subnet_id = aws_subnet.public3_subnet.id
    route_table_id = aws_route_table.rt_publicprimary.id
}

# Creating Route Table for Private Subnets
resource "aws_route_table" "rt_privateprimary" {
    vpc_id = aws_vpc.vpc1.id
    route = []
    tags = {
            Name = "PrivateRouteTable us-east-1"
        }

}
# Associate private subnet 1 with internal route table
resource "aws_route_table_association" "rt_associate_private1" {
    subnet_id = aws_subnet.private1_subnet.id
    route_table_id = aws_route_table.rt_privateprimary.id
}
# Associate private subnet 2 with internal route table
resource "aws_route_table_association" "rt_associate_private2" {
    subnet_id = aws_subnet.private2_subnet.id
    route_table_id = aws_route_table.rt_privateprimary.id
}
# Associate private subnet 3 with internal route table
resource "aws_route_table_association" "rt_associate_private3" {
    subnet_id = aws_subnet.private3_subnet.id
    route_table_id = aws_route_table.rt_privateprimary.id
}