locals {
  ami_id      = try(coalesce(var.ami, data.aws_ami.ubuntu.id), null)
  owners      = var.business_divsion
  environment = var.environment
  name        = "${var.business_divsion}-${var.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
}