variable "region" {}
variable "project_name" {}

# vpc variables
variable "vpc_cidr_block" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_app_subnet_az1_cidr" {}
variable "private_app_subnet_az2_cidr" {}
variable "private_data_subnet_az1_cidr" {}
variable "private_data_subnet_az2_cidr" {}
variable "domain_name" {}
variable "alternative_names" {}
variable "container_image" {}