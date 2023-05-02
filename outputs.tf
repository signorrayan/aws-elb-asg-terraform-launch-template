########################################################
# Bastion Launch Template Outputs
########################################################

output "bastion_launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.bastion.id
}

output "bastion_launch_template_latest_version" {
  description = "Launch Template Latest Version"
  value       = aws_launch_template.bastion.latest_version
}

output "bastion_public_ip" {
  value = aws_launch_template.bastion.network_interfaces.associate_public_ip_address
}

# Autoscaling Outputs
output "bastion_autoscaling_group_id" {
  description = "Autoscaling Group ID"
  value       = aws_autoscaling_group.bastion.id
}

output "bastion_autoscaling_group_name" {
  description = "Autoscaling Group Name"
  value       = aws_autoscaling_group.bastion.name
}

output "bastion_autoscaling_group_arn" {
  description = "Autoscaling Group ARN"
  value       = aws_autoscaling_group.bastion.arn
}


########################################################
# Private Launch Template Outputs
########################################################

output "private_launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.private.id
}

output "private_launch_template_latest_version" {
  description = "Launch Template Latest Version"
  value       = aws_launch_template.private.latest_version
}

# Autoscaling Outputs
output "private_autoscaling_group_id" {
  description = "Autoscaling Group ID"
  value       = aws_autoscaling_group.private.id
}

output "private_autoscaling_group_name" {
  description = "Autoscaling Group Name"
  value       = aws_autoscaling_group.private.name
}

output "private_autoscaling_group_arn" {
  description = "Autoscaling Group ARN"
  value       = aws_autoscaling_group.private.arn
}


########################################################
# VPC Output Values
########################################################

# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# VPC CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# VPC Private Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

# VPC Public Subnets
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# VPC NAT gateway Public IP
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# VPC AZs
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = module.vpc.azs
}


########################################################
# Security groups
########################################################

# Public Bastion Host Security Group Outputs
output "public_bastion_sg_group_id" {
  description = "The ID of the security group"
  value       = module.public_bastion_sg.security_group_id
}
output "public_bastion_sg_group_vpc_id" {
  description = "The VPC ID"
  value       = module.public_bastion_sg.security_group_vpc_id
}
output "public_bastion_sg_group_name" {
  description = "The name of the security group"
  value       = module.public_bastion_sg.security_group_name
}

# Private EC2 Instances Security Group Outputs
output "private_sg_group_id" {
  description = "The ID of the security group"
  value       = module.private_sg.security_group_id
}
output "private_sg_group_vpc_id" {
  description = "The VPC ID"
  value       = module.private_sg.security_group_vpc_id
}
output "private_sg_group_name" {
  description = "The name of the security group"
  value       = module.private_sg.security_group_name
}


########################################################
# AWS EC2 Instance Terraform Outputs
########################################################

# # Public EC2 Instances - Bastion Host
# output "ec2_bastion_public_ids" {
#   description = "List of IDs of instances"
#   value       = module.ec2_public.id
# }
# output "ec2_bastion_public_ip" {
#   description = "List of Public ip address assigned to the instances"
#   value       = module.ec2_public.public_ip
# }
#
# output "ec2_bastion_security_group_ids" {
#   value = module.ec2_public.security_gruops
# }
#
# # App1 - Private EC2 Instances
# ## ec2_private_instance_ids
# output "app1_ec2_private_instance_ids" {
#   description = "List of IDs of instances"
#   value       = module.ec2_private_app1.*.id
# }
# ## ec2_private_ip
# output "app1_ec2_private_ip" {
#   description = "List of private IP addresses assigned to the instances"
#   value       = module.ec2_private_app1.*.private_ip
# }
#
# output "app1_ec2_security_groups" {
#   value = module.ec2_private_app1.security_gruops
# }


########################################################
# Terraform AWS Application Load Balancer (ALB) Outputs
########################################################

output "this_lb_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb.lb_id
}

output "this_lb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb.lb_arn
}

output "this_lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.lb_dns_name
}

output "this_lb_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch."
  value       = module.alb.lb_arn_suffix
}

output "this_lb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = module.alb.lb_zone_id
}

output "http_tcp_listener_arns" {
  description = "The ARN of the TCP and HTTP load balancer listeners created."
  value       = module.alb.http_tcp_listener_arns
}

output "http_tcp_listener_ids" {
  description = "The IDs of the TCP and HTTP load balancer listeners created."
  value       = module.alb.http_tcp_listener_ids
}

output "https_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners created."
  value       = module.alb.https_listener_arns
}

output "https_listener_ids" {
  description = "The IDs of the load balancer listeners created."
  value       = module.alb.https_listener_ids
}

output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = module.alb.target_group_arns
}

output "target_group_arn_suffixes" {
  description = "ARN suffixes of our target groups - can be used with CloudWatch."
  value       = module.alb.target_group_arn_suffixes
}

output "target_group_names" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
  value       = module.alb.target_group_names
}

output "target_group_attachments" {
  description = "ARNs of the target group attachment IDs."
  value       = module.alb.target_group_attachments
}