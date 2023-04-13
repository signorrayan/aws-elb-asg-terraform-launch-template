# EC2 Instances that will be created in VPC Private Subnets
module "ec2_private_app2" {
  source        = "git::https://github.com/signorrayan/aws-ec2-terraform-module.git?ref=v1.3.5"
  name          = "${var.environment}-app2"
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  # user_data = file("${path.module}/apache-install.sh")
  key_name = var.instance_keypair
  #subnet_id = module.vpc.private_subnets[0] # Single Instance
  vpc_security_group_ids = [module.private_sg.security_group_id]
  # instance_count = 3
  subnet_id = element(module.vpc.private_subnets, 0)

  # tags = local.common_tags
  depends_on = [module.vpc]
}