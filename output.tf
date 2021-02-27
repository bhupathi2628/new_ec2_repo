output "aws_vpc_id" {
  description = "this output of vpc id"
  value       = aws_vpc.my_vpc.id
}

output "aws_publicsubnet_id" {
  description = "this output of publicsubnet"
  value       = aws_subnet.public_subnet.id
}

output "aws_security_gr_id" {
  description = "this output of security groups"
  value       = aws_security_group.terraform_private_sg.id
}



# output "aws_privatesubnet_id" {
#   description = "this output of privatesubnet"
#   value       = aws_subnet.private_subnet.id
# }