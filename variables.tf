#####################################
# Generic
#####################################

variable "region" {
  description = "The instance region"
  type        = string
  default     = "eu-west-1"
}


#####################################
variable "template_name" {
  description = "The name of aws launch template"
  type        = string
  default     = null
}

variable "ebs_volume_size" {
  description = "The size of the volume using in the aws_launch_template"
  type        = number
  default     = 10
}

variable "cpu_core_count" {
  description = "Sets the number of CPU cores for an instance." # This option is only supported on creation of instance type that support CPU Options https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-optimize-cpu.html#cpu-options-supported-instances-values
  type        = number
  default     = null
}

variable "cpu_threads_per_core" {
  description = "Sets the number of CPU threads per core for an instance (has no effect unless cpu_core_count is also set)."
  type        = number
  default     = null
}

variable "ebs_optimized" {
  description = "An Amazon EBS–optimized instance uses an optimized configuration stack and provides additional, dedicated capacity for Amazon EBS I/O"
  type        = bool
  default     = false
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "The type of configurations of computing resources"
  type        = string
  default     = "t3.micro"
}

variable "instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance"
  type        = string
  default     = "awsec2server"
}

variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}

variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "DevOps"
}



#######################
# VPC Input Variables #
#######################

# VPC Name
variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "myvpc"
}

# VPC CIDR Block
variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

# VPC Availability Zones
variable "vpc_availability_zones" {
  description = "VPC Availability Zones"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}

# VPC Public Subnets
variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

# VPC Private Subnets
variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# VPC Database Subnets
variable "vpc_database_subnets" {
  description = "VPC Database Subnets"
  type        = list(string)
  default     = ["10.0.151.0/24", "10.0.152.0/24"]
}

# VPC Create Database Subnet Group (True / False)
variable "vpc_create_database_subnet_group" {
  description = "VPC Create Database Subnet Group"
  type        = bool
  default     = true
}

# VPC Create Database Subnet Route Table (True or False)
variable "vpc_create_database_subnet_route_table" {
  description = "VPC Create Database Subnet Route Table"
  type        = bool
  default     = true
}


# VPC Enable NAT Gateway (True or False)
variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateways for Private Subnets Outbound Communication"
  type        = bool
  default     = true
}

# VPC Single NAT Gateway (True or False)
variable "vpc_single_nat_gateway" {
  description = "Enable only single NAT Gateway in one Availability Zone to save costs during our demos"
  type        = bool
  default     = true
}

variable "private_instance_count" {
  description = "The number of EC2 Instances that want to create."
  type        = number
  default     = 1
}

variable "update_default_version" {
  type    = bool
  default = true
}

variable "delete_on_termination" {
  type    = bool
  default = true
}

variable "volume_type" {
  description = "the type of EBS"
  type        = string
  default     = "gp2"
}

variable "monitoring" {
  description = "To enable monitoring or not"
  type        = bool
  default     = true
}

####################################
# Autoscaling group
####################################
variable "asg_name_prefix" {
  description = "The name prefix for aws_autoscaling_group resource"
  type        = string
  default     = "asg_"
}

variable "asg_desired_capacity" {
  type    = number
  default = 2
}

variable "asg_max_size" {
  type    = number
  default = 10
}

variable "asg_min_size" {
  type    = number
  default = 2
}

variable "asg_tag_key" {
  type    = string
  default = "Owners"
}

variable "asg_tag_value" {
  type    = string
  default = "DevOps-Team"
}

variable "asg_tag_propagate_at_launch" {
  type    = bool
  default = true
}

################################################
variable "sns_topic_endpoint" {
  description = "The endpoint email to send notifications"
  type        = string
}

variable "sns_topic_protocol" {
  type    = string
  default = "email"
}