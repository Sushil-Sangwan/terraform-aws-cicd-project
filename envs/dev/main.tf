provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr        = "10.0.0.0/16"
  public_subnet_1 = "10.0.1.0/24"
  public_subnet_2 = "10.0.2.0/24"
  private_subnet_1 = "10.0.3.0/24"
  private_subnet_2 = "10.0.4.0/24"
}

module "alb" {
  source = "../../modules/alb"

  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}

module "ecs" {
  source = "../../modules/ecs"

  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  alb_sg_id         = module.alb.alb_sg_id
  target_group_arn  = module.alb.target_group_arn

  image = "sushilsangwan/my-nginx:latest"
}