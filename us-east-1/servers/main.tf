# Provision EC2 servers for private subnets
resource "aws_ec2_host" "appserver_1" {
  ami = "${lookup(var.AMI, var.aws_region)}"
  instance_type     = "t2.micro"
  # availability_zone = "us-west-1a" ---- curious if this automatically places in the subnet in that AZ or if it's better to use the subnet_id reference
  # host_recovery     = "on"
  auto_placement    = "on"
  subnet_id = "${aws_subnet.private1_subnet.id}"
  tags = {
        Name = "App Server 1"
    }
}
resource "aws_ec2_host" "appserver_2" {
  instance_type     = "t2.micro"
  # availability_zone = "us-west-1b"
  auto_placement    = "on"
  subnet_id = "${aws_subnet.private2_subnet.id}"
  tags = {
        Name = "App Server 2"
    }
}
resource "aws_ec2_host" "appserver_3" {
  instance_type     = "t2.micro"
  # availability_zone = "us-west-1c"
  auto_placement    = "on"
  subnet_id = "${aws_subnet.private3_subnet.id}"
  tags = {
        Name = "App Server 3"
    }
}
################################### SECURITY GROUPS ###########################################
# Create security groups for servers
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpc1.cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.vpc1.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}