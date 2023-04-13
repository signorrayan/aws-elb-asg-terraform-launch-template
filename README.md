# terraform-aws-elb-asg-launch-templates

This is a sample of AWS ELB (Elastic Load Balancer), ASG (Auto Scaling Groups), Launch Template.

- Multiple modules have been used for [AWS EC2 instances](https://github.com/signorrayan/aws-ec2-terraform-module), security-groups, VPCs, ELB.


### Sample Output after executing `terraform apply`:
```
Outputs:

app1_ec2_private_instance_ids = [
  {
    "dev-app1-1" = "i-0c6554164e09acbeb"
    "dev-app1-2" = "i-016d33311de2ed786"
    "dev-app1-3" = "i-0757ff6e42b84b58d"
  },
]
app1_ec2_private_ip = [
  {
    "dev-app1-1" = "10.0.1.x"
    "dev-app1-2" = "10.0.1.xx"
    "dev-app1-3" = "10.0.1.xxx"
  },
]
app1_ec2_security_groups = {
  "dev-app1-1" = toset([
    "sg-05d0f4b5a6b5806fa",
  ])
  "dev-app1-2" = toset([
    "sg-05d0f4b5a6b5806fa",
  ])
  "dev-app1-3" = toset([
    "sg-05d0f4b5a6b5806fa",
  ])
}
app2_ec2_private_instance_ids = {
  "dev-app2-1" = "i-055f20922633caaac"
}
app2_ec2_private_ip = {
  "dev-app2-1" = "10.0.1.x"
}
app2_ec2_security_groups = {
  "dev-app1-1" = toset([
    "sg-05d0f4b5a6b5806fa",
  ])
  "dev-app1-2" = toset([
    "sg-05d0f4b5a6b5806fa",
  ])
  "dev-app1-3" = toset([
    "sg-05d0f4b5a6b5806fa",
  ])
}
autoscaling_group_arn = "arn:aws:autoscaling:eu-west-1:xxxxxxx:autoScalingGroup:ade999d9-2cfc-4c05-8b99-04d993a585d4:autoScalingGroupName/asg_2023041313412920980000000d"
autoscaling_group_id = "asg_2023041313412920980000000d"
autoscaling_group_name = "asg_2023041313412920980000000d"
azs = tolist([
  "eu-west-1a",
  "eu-west-1b",
])
ec2_bastion_public_instance_ids = {
  "dev-BastionHost-1" = "i-05f2ac77563e47002"
}
ec2_bastion_public_ip = {
  "dev-BastionHost-1" = "x.x.x.x"
}
ec2_bastion_security_group_ids = {
  "dev-BastionHost-1" = toset([
    "sg-027c56fd7610c1e20",
  ])
}
http_tcp_listener_arns = [
  "arn:aws:elasticloadbalancing:eu-west-1:xxxxxxx:listener/app/DevOps-dev-alb/9ab00a42608590fe/a76472f3ee3e26c0",
]
http_tcp_listener_ids = [
  "arn:aws:elasticloadbalancing:eu-west-1:xxxxxxx:listener/app/DevOps-dev-alb/9ab00a42608590fe/a76472f3ee3e26c0",
]
https_listener_arns = []
https_listener_ids = []
launch_template_id = "lt-0fa256d6ed9bb6348"
launch_template_latest_version = 1
nat_public_ips = tolist([
  "52.16.14.250",
])
private_sg_group_id = "sg-05d0f4b5a6b5806fa"
private_sg_group_name = "private-sg-20230413133857665700000004"
private_sg_group_vpc_id = "vpc-0fc074560c3751434"
private_subnets = [
  "subnet-0a1d59e657cc464b3",
  "subnet-00a479c613649f013",
]
public_bastion_sg_group_id = "sg-027c56fd7610c1e20"
public_bastion_sg_group_name = "public-bastion-sg-20230413133857665600000002"
public_bastion_sg_group_vpc_id = "vpc-0fc074560c3751434"
public_subnets = [
  "subnet-0d072bf91668633bf",
  "subnet-09d8fa7b7e8cc36e6",
]
target_group_arn_suffixes = [
  "targetgroup/app1-2023041313412773730000000c/39274473a4269fa2",
]
target_group_arns = [
  "arn:aws:elasticloadbalancing:eu-west-1:xxxxxxx:targetgroup/app1-2023041313412773730000000c/39274473a4269fa2",
]
target_group_attachments = {
  "0.my_app1_vm1" = "arn:aws:elasticloadbalancing:eu-west-1:xxxxxxx:targetgroup/app1-2023041313412773730000000c/39274473a4269fa2-2023041313412935370000000e"
  "0.my_app1_vm2" = "arn:aws:elasticloadbalancing:eu-west-1:xxxxxxx:targetgroup/app1-2023041313412773730000000c/39274473a4269fa2-2023041313412949110000000f"
}
target_group_names = [
  "app1-2023041313412773730000000c",
]
this_lb_arn = "arn:aws:elasticloadbalancing:eu-west-1:xxxxxx:loadbalancer/app/DevOps-dev-alb/9ab00a42608590fe"
this_lb_arn_suffix = "app/DevOps-dev-alb/9ab00a42608590fe"
this_lb_dns_name = "DevOps-dev-alb-xxxxxxx.eu-west-1.elb.amazonaws.com"
this_lb_id = "arn:aws:elasticloadbalancing:eu-west-1:xxxxxxx:loadbalancer/app/DevOps-dev-alb/9ab00a42608590fe"
this_lb_zone_id = "Z32O12XQLNTSW2"
vpc_cidr_block = "10.0.0.0/16"
vpc_id = "vpc-0fc074560c3751434"

```
