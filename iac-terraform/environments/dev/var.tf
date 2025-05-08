variable "region" {
  default = "ap-south-2"
}

variable "aws_account_id" {
  default = "767398052234"
}

variable "environment" {
  default = "proglint-preprod"
}

variable "global_tags" {
  type = map(string)

  default = {
    "Customer"  = "proglint"
    "CreatedBy" = "cicd-terraform"
    "Application"  = "proglint-app"
    "ContactEmail" = "support-devops@proglint.com"
    "IT_OWNER_EMAIL" = "jagadish@proglint.com"
    "TECH_STACK_OWNER" = "Jagadish"
    "TECH_STACK_OWNER_EMAIL" = "N/A"
    "FUNC_OWNER_EMAIL" = "jagadish@proglint.com"
    "APP_NAME" = "proglint-app"
    "APP_ID" = "NA"
  }
}

variable "shared_keypair" {
  default = "proglint-preprod-admin"
}

variable "ec2_policy_for_ssm" {
  default = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}