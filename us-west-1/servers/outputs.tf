## Output variable which will store the arn of instance 
## and display after terraform apply command.
output "ec2_arn" {
  ## Value depends on resource name and type (same as that of main.tf)
  value = aws_instance.my-machine.arn
}
## Output variable which will store instance public IP 
## and display after terraform apply command 
output "instance_ip_addr" {
  value       = aws_instance.my-machine.public_ip
  description = "The public IP address of the main server instance."
}