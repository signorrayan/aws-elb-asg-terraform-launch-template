# AWS EC2 Instance Terraform Module
# Bastion Host - EC2 Instance that will be created in VPC Public Subnet
module "ec2_public" {
  source = "git::https://github.com/signorrayan/aws-ec2-terraform-module.git?ref=v1.3.5"
  # source  = "terraform-aws-modules/ec2-instance/aws"
  # version = "2.17.0"

  # insert the 10 required variables here
  name                   = "${var.environment}-BastionHost"
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  subnet_id              = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  # tags = local.common_tags
}
