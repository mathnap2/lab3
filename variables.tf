variable "aws_region" {
  description = "AWS region (AWS Academy Learner Lab only allows us-east-1 / us-west-2)"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "project_name" {
  description = "Prefix used for resource names"
  type        = string
  default     = "lab3-asg"
}

variable "asg_min_size" {
  description = "Minimum number of instances (the steady state)"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances when CPU is high"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Initial number of instances"
  type        = number
  default     = 1
}

variable "cpu_high_threshold" {
  description = "Average ASG CPU % above which one instance is added"
  type        = number
  default     = 50
}

variable "cpu_low_threshold" {
  description = "Average ASG CPU % below which one instance is removed"
  type        = number
  default     = 20
}
