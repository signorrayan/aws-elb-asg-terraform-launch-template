resource "aws_launch_template" "this" {
  name        = var.template_name
  description = "DevOps Launch Template"

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = var.ebs_volume_size
      delete_on_termination = var.delete_on_termination
      volume_type           = var.volume_type # default is gp2
    }
  }

  # cpu_options {
  #   core_count       = var.cpu_core_count
  #   threads_per_core = var.cpu_threads_per_core
  # }

  image_id               = try(coalesce(var.ami, data.aws_ami.ubuntu.id), null)
  instance_type          = var.instance_type
  ebs_optimized          = var.ebs_optimized
  update_default_version = var.update_default_version
  key_name = var.instance_keypair


  # TODO : change the key_name, and implement a key pair
  # key_name = "test"

  monitoring {
    enabled = var.monitoring
  }

  # network_interfaces {
  #   associate_public_ip_address = true
  # }

  vpc_security_group_ids = [module.private_sg.security_group_id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "sig-asg"
    }
  }
}