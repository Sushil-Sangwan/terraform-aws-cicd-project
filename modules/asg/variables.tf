variable "vpc_id" {
  description = "VPC ID where EC2 will run"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs for ASG"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group of ALB"
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN from ALB"
  type        = string
}