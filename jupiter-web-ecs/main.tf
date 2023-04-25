# configure aws provider

provider "aws" {
  region    = var.region
  profile   = "devops"
}

# create vpc
module "vpc" {
  source                            = "../modules/vpc"
  region                            = var.region
  project_name                      = var.project_name 
  vpc_cidr_block                    = var.vpc_cidr_block
  public_subnet_az1_cidr            = var.public_subnet_az1_cidr
  public_subnet_az2_cidr            = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr       = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr       = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr      = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr      = var.private_data_subnet_az2_cidr

}

module "nat-gateway" {
  source = "../modules/nat-gateway"
  public_subnet_az1_id        = module.vpc.public_subnet_az1_id
  public_subnet_az2_id        = module.vpc.public_subnet_az2_id
  internet_gateway            = module.vpc.internet_gateway
  vpc_id                      = module.vpc.vpc_id
  private_app_subnet_az1_id   = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id   = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az1_id  = module.vpc.private_data_subnet_az1_id
  private_data_subnet_az2_id  = module.vpc.private_data_subnet_az2_id

}

module "security-groups" {
  source = "../modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

module "ecs-tasks-execution-role" {
  source = "../modules/ecs-tasks-execution-role"
  project_name = module.vpc.project_name
}

module "ecm" {
  source            = "../modules/ecm"
  domain_name       = var.domain_name
  alternative_names = var.alternative_names
}

module "alb" {
  source                = "../modules/alb"
  project_name          = module.vpc.project_name
  alb_security_group_id = module.security-groups.alb_security_group_id
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  public_subnet_az2_id  = module.vpc.public_subnet_az2_id
  vpc_id                = module.vpc.vpc_id
  certificate_arn       = module.ecm.certificate_arn
}