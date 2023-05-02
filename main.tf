# ================================================================= #
# ============================ Modules ============================ #
# ================================================================= #

module "vpc" {
  source = "./modules/vpc"
}


# Application Load Balancer (ALB)
# -------------------------------
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.6.0"

  name               = "${local.name}-alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets = [
    module.vpc.public_subnets[0],
    module.vpc.public_subnets[1]
  ]
  security_groups = [module.loadbalancer_sg.security_group_id]
  # Listeners
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
  # Target Groups
  target_groups = [
    # App1 Target Group
    {
      name_prefix      = "app1-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/" # Health check path
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      tags             = local.common_tags # Target Group Tags
    }
  ]
  tags = local.common_tags # ALB Tags
  # depends_on = [aws_autoscaling_group.private]
}



# Security Group for Private EC2 Instances
# ----------------------------------------
module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

  name                = "private-sg"
  description         = "Security group with HTTP & SSH ports open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id              = module.vpc.vpc_id
  ingress_rules       = ["ssh-tcp", "http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  tags                = local.common_tags
}



# Security Group for Public Load Balancer
# ---------------------------------------
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
  # ingress_with_cidr_blocks = [
  #   {
  #     from_port   = 81
  #     to_port     = 81
  #     protocol    = 6
  #     description = "Allow Port 81 from internet"
  #     cidr_blocks = "0.0.0.0/0"
  #   },
  # ]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = local.common_tags
}


# Security Group for Public Bastion Host
# --------------------------------------
module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

  name        = "public-bastion-sg"
  description = "Security group with SSH port open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc.vpc_id
  # Ingress Rules & CIDR Block
  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = local.common_tags
}

# ================================================================= #
#                    End of imported modules                        #
# ================================================================= #


#####################################################################
################## Private Launch Template Resource #################
#####################################################################

resource "aws_launch_template" "private" {
  name_prefix = "${var.template_name}-private-"
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
  instance_type          = var.private_instance_type
  ebs_optimized          = var.ebs_optimized
  update_default_version = var.update_default_version
  key_name               = var.instance_keypair
  user_data              = filebase64("${path.module}/user-data.sh")
  # user_data = file("${path.module}/user-data.sh")

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
      Name = "${var.template_name}-private"
    }
  }
}


########################################################################
###################### Private AutoScaling Group #######################
########################################################################

# Autoscaling Group Resource
resource "aws_autoscaling_group" "private" {
  name_prefix         = var.asg_name_prefix
  desired_capacity    = var.asg_desired_capacity
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  vpc_zone_identifier = module.vpc.private_subnets
  /*[
    module.vpc.private_subnet[0],
    module.vpc.private_subnet[1]
  ]*/
  target_group_arns = module.alb.target_group_arns
  health_check_type = "EC2"
  # health_check_grace_period = 300 # default is 300 seconds

  # Launch Template
  launch_template {
    id      = aws_launch_template.private.id
    version = aws_launch_template.private.latest_version
  }

  # Instance Refresh
  instance_refresh {
    strategy = "Rolling"
    preferences {
      #instance_warmup = 300 # Default behavior is to use the Auto Scaling Group's health check grace period.
      min_healthy_percentage = 50
    }
    triggers = [/*"launch_template",*/ "desired_capacity"] # You can add any argument from ASG here, if those has changes, ASG Instance Refresh will trigger
  }

  tag {
    key                 = var.asg_tag_key
    value               = var.asg_tag_value
    propagate_at_launch = var.asg_tag_propagate_at_launch
  }
}


# Autoscaling Notifications
#==========================
## SNS - Topic
resource "aws_sns_topic" "private_asg_sns_topic" {
  name = "asg-sns-topic"
}

## SNS - Subscription
resource "aws_sns_topic_subscription" "private_asg_sns_topic_subscription" {
  topic_arn = aws_sns_topic.private_asg_sns_topic.arn
  protocol  = var.sns_topic_protocol
  endpoint  = var.sns_topic_endpoint
}

## Create Autoscaling Notification Resource
resource "aws_autoscaling_notification" "private_asg_notifications" {
  group_names = [aws_autoscaling_group.private.id]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = aws_sns_topic.private_asg_sns_topic.arn
}


# Target Tracking Scaling Policies
#=================================
# TTS - Scaling Policy-1: Based on CPU Utilization
# Define Autoscaling Policies and Associate them to Autoscaling Group
resource "aws_autoscaling_policy" "private_avg_cpu_policy_greater_than_xx" {
  name                      = "avg-cpu-policy-greater-than-xx"
  policy_type               = "TargetTrackingScaling" # Important Note: The policy type, either "SimpleScaling", "StepScaling" or "TargetTrackingScaling". If this value isn't provided, AWS will default to "SimpleScaling."
  autoscaling_group_name    = aws_autoscaling_group.private.id
  estimated_instance_warmup = 180 # defaults to ASG default cooldown 300 seconds if not set
  # CPU Utilization is above 50
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }

}

# TTS - Scaling Policy-2: Based on ALB Target Requests
# ====================================================
resource "aws_autoscaling_policy" "alb_target_requests_greater_than_yy" {
  name                      = "alb-target-requests-greater-than-yy"
  policy_type               = "TargetTrackingScaling" # Important Note: The policy type, either "SimpleScaling", "StepScaling" or "TargetTrackingScaling". If this value isn't provided, AWS will default to "SimpleScaling."
  autoscaling_group_name    = aws_autoscaling_group.private.id
  estimated_instance_warmup = 120 # defaults to ASG default cooldown 300 seconds if not set
  # Number of requests > 10 completed per target in an Application Load Balancer target group.
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${module.alb.lb_arn_suffix}/${module.alb.target_group_arn_suffixes[0]}"
    }
    target_value = 10.0
  }
}


# Create Scheduled Actions for private instances
#===============================================
### Create Scheduled Action-1: Increase capacity during business hours
resource "aws_autoscaling_schedule" "increase_capacity_7am" {
  scheduled_action_name  = "increase-capacity-7am"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 8
  start_time             = "2024-04-12T11:00:00Z" # Time should be provided in UTC Timezone (11am UTC = 7AM EST)
  recurrence             = "00 09 * * *"
  autoscaling_group_name = aws_autoscaling_group.private.id
}
### Create Scheduled Action-2: Decrease capacity during business hours
resource "aws_autoscaling_schedule" "decrease_capacity_5pm" {
  scheduled_action_name  = "decrease-capacity-5pm"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  start_time             = "2024-04-12T21:00:00Z" # Time should be provided in UTC Timezone (9PM UTC = 5PM EST)
  recurrence             = "00 21 * * *"
  autoscaling_group_name = aws_autoscaling_group.private.id
}


#####################################################################
################## Bastion Launch Template Resource #################
#####################################################################

resource "aws_launch_template" "bastion" {
  name_prefix            = "${var.template_name}-bastion-"
  description            = "DevOps Launch Template"
  image_id               = try(coalesce(var.ami, data.aws_ami.ubuntu.id), null)
  instance_type          = var.bastion_instance_type
  ebs_optimized          = var.ebs_optimized
  update_default_version = var.update_default_version
  key_name               = var.instance_keypair
  # vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  # user_data              = var.userdata_file_content != "" ? base64encode(var.userdata_file_content) : base64encode(templatefile("${path.module}/bastion-userdata.sh", { HOSTED_ZONE_ID = var.hosted_zone_id, NAME_PREFIX = var.name_prefix }))

  block_device_mappings {
    device_name = var.device_name
    ebs {
      volume_size           = var.ebs_volume_size
      delete_on_termination = var.delete_on_termination
      volume_type           = var.volume_type # default is gp2
    }
  }

  monitoring {
    enabled = var.monitoring
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.template_name}-bastion"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [module.public_bastion_sg.security_group_id, module.loadbalancer_sg.security_group_id]
    subnet_id                   = element(module.vpc.public_subnets, 0)
  }

  lifecycle {
    create_before_destroy = true
  }
  # cpu_options {
  #   core_count       = var.cpu_core_count
  #   threads_per_core = var.cpu_threads_per_core
  # }

}


# ================================================================= #
# ================== Bastion AutoScaling Group ==================== #
# ================================================================= #

# Autoscaling Group Resource
# --------------------------
resource "aws_autoscaling_group" "bastion" {
  name_prefix         = var.asg_name_prefix
  desired_capacity    = var.bastion_asg_desired_capacity
  max_size            = var.bastion_asg_max_size
  min_size            = var.bastion_asg_min_size
  vpc_zone_identifier = module.vpc.public_subnets
  target_group_arns   = module.alb.target_group_arns
  health_check_type = "EC2"

  # health_check_grace_period = 300 # default is 300 seconds

  # Launch Template
  launch_template {
    id      = aws_launch_template.bastion.id
    version = aws_launch_template.bastion.latest_version
  }

  # Instance Refresh
  instance_refresh {
    strategy = "Rolling"
    preferences {
      #instance_warmup = 300 # Default behavior is to use the Auto Scaling Group's health check grace period.
      min_healthy_percentage = 50
    }
    triggers = [/*"launch_template",*/ "desired_capacity"] # You can add any argument from ASG here, if those has changes, ASG Instance Refresh will trigger
  }

  tag {
    key                 = var.asg_tag_key
    value               = var.asg_tag_value
    propagate_at_launch = var.asg_tag_propagate_at_launch
  }
}


# Bastion Autoscaling Notifications
# ---------------------------------
## SNS - Topic
resource "aws_sns_topic" "bastion_asg_sns_topic" {
  name_prefix = "bastion-asg-sns-topic-"
}

## SNS - Subscription
resource "aws_sns_topic_subscription" "bastion_asg_sns_topic_subscription" {
  topic_arn = aws_sns_topic.bastion_asg_sns_topic.arn
  protocol  = var.sns_topic_protocol
  endpoint  = var.sns_topic_endpoint
}

## Create Autoscaling Notification Resource
resource "aws_autoscaling_notification" "bastion_asg_notifications" {
  group_names = [aws_autoscaling_group.bastion.id]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = aws_sns_topic.bastion_asg_sns_topic.arn
}


# Bastion Target Tracking Scaling Policies
# ----------------------------------------
# TTS - Scaling Policy-1: Based on CPU Utilization
# Define Autoscaling Policies and Associate them to Autoscaling Group
resource "aws_autoscaling_policy" "bastion_avg_cpu_policy_greater_than_xx" {
  name        = "bastion-avg-cpu-policy-greater-than-xx"
  policy_type = "TargetTrackingScaling"
  # Important Note: The policy type, either "SimpleScaling", "StepScaling" or "TargetTrackingScaling". If this value isn't provided, AWS will default to "SimpleScaling."
  autoscaling_group_name    = aws_autoscaling_group.bastion.id
  estimated_instance_warmup = 180 # defaults to ASG default cooldown 300 seconds if not set
  # CPU Utilization is above 50
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

# ================================================================= #
# =============== End of Bastion Host configuration =============== #
# ================================================================= #


#####################################################################
#####################  Key pair for instances #######################
#####################################################################
resource "aws_key_pair" "key_pair" {
  key_name   = var.instance_keypair
  public_key = file("./pubkey/awsec2server.pub")
}