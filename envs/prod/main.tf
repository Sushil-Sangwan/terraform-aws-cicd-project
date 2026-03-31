provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr        = "10.1.0.0/16"
  public_subnet_1 = "10.1.1.0/24"
  public_subnet_2 = "10.1.2.0/24"
  private_subnet_1 = "10.1.3.0/24"
  private_subnet_2 = "10.1.4.0/24"
}

module "asg" {
  source = "../../modules/asg"

  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  alb_sg_id        = module.alb.alb_sg_id
  target_group_arn = module.alb.target_group_arn
}