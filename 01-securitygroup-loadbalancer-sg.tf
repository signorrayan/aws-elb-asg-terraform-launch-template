# Security Group for Public Load Balancer
module "loadbalancer_sg" {
  source = "terraform-aws-modules/security-group/aws"
  # version = "3.18.0"
  version = "4.17.1"

  name        = "loadbalancer-sg"
  description = "Security group with HTTP port open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc.vpc_id
  # Ingress Rules & CIDR Block
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 81
      to_port     = 81
      protocol    = 6
      description = "Allow Port 81 from internet"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = local.common_tags
}
