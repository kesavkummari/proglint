terraform {
  backend "s3" {
    bucket         = "proglint-iac-terraform-statefiles"
    key            = "proglint-dev-terraform.tfstate"
    region         = "ap-south-2"
    #dynamodb_table = "proglint-terraform"
    profile = "iac-terraform-automation"
  }
}

provider "aws" {
  # assume_role {
  #   role_arn = "arn:aws:iam::${var.aws_account_id}:role/terraform-automation"
  # }
  region = var.region
}

data "terraform_remote_state" "proglint_preprod_vpc" {
  backend = "s3"

  config = {
    bucket = "proglint-iac-terraform-statefiles"
    key    = "core-infra-terraform.tfstate"
    region = "ap-south-2"
  }
}


module "proglint_dev" {
  source = "../../modules/proglint/proglint-dev"

  # App Instance Inputs
  proglint_web_vpc_id              = data.terraform_remote_state.proglint_preprod_vpc.outputs.vpc_id
  proglint_web_private_subnets     = data.terraform_remote_state.proglint_preprod_vpc.outputs.private_subnet_1
  proglint_web_data_subnets        = data.terraform_remote_state.proglint_preprod_vpc.outputs.data_subnet_1
  proglint_web_data_subnets_2      = data.terraform_remote_state.proglint_preprod_vpc.outputs.data_subnet_2

  ec2_policy_for_ssm           = var.ec2_policy_for_ssm
  proglint_web_additional_tags     = var.global_tags
  proglint_web_environment         = "dev"
  proglint_web_key_name            = "hgts-shared-preprod"
  proglint_web_admin_web_sg_id     = data.terraform_remote_state.proglint_preprod_vpc.outputs.web_sg
  proglint_web_admin_windows_sg_id = data.terraform_remote_state.proglint_preprod_vpc.outputs.windows_sg

  proglint_web_app_instance_size   = "t3.medium"
  proglint_web_global_source_cidrs = ["10.0.0.0/8"]

  # RDS PostgreSQL Instance Inputs
  rds_instance_identifier = "hgts-dev-pgsql"
  rds_allocated_storage   = 20
  rds_storage_type        = "gp3"
  rds_instance_class      = "db.r5.large"
  database_port           = 5432 # Default PostgreSQL port
  rds_subnet_group        = data.terraform_remote_state.proglint_preprod_vpc.outputs.data_subnet_1
  rds_admin_sg            = data.terraform_remote_state.proglint_preprod_vpc.outputs.linux_sg # Updated to use remote state
  rds_engine_type         = "postgres"
  rds_engine_version      = "17.4" # Use latest supported version as per AWS
  database_user           = "proglint_usr"
  database_password       = "P#ssword2025"
  backup_window           = "02:00-03:00"
  backup_retention_period = 7
  maintenance_window      = "sun:04:00-sun:07:00"
  rds_is_multi_az         = false
}


