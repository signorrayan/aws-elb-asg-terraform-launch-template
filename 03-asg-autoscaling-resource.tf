# Autoscaling Group Resource
resource "aws_autoscaling_group" "this" {
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
  #health_check_grace_period = 300 # default is 300 seconds
  # Launch Template
  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
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
