
# output "availability_zones" {
#   value = data.aws_availability_zones.available
# }

# output "subnet_ids" {
#   value = data.aws_subnets.available.ids
# }

# output "subnet_cidr_blocks" {
#   value = [for s in data.aws_subnet.available : s.cidr_block]
# }

# output "vpc_subnet_pair" {
#   value = random_shuffle.vpc_subnet_pair.result
# }

# output "aws_lb_url" {
#   value = aws_lb.lb.dns_name
# }

# output "app_url" {
#   value = "http://${aws_lb.lb.dns_name}"
# }

output "public_ip" {
  value = aws_internet_gateway.gw.id
}

output "instance_public_ip" {
  value = aws_instance.app.public_ip
}

output "ssh_access" {
  value     = "ssh -i ${tls_private_key.main.private_key_pem} ec2-user@${aws_instance.app.public_ip}"
  sensitive = true
}
