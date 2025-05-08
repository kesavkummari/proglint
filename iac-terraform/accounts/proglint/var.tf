variable "region" {
  default = "ap-south-2"
}

variable "aws_account_id" {
  default = "767398052234"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "instance_tenancy" {
  default = "default"
}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = [] # You can set a default value if needed
}


variable "public_subnets" {
  description = "List of Public subnet IDs"
  type        = list(string)
  default     = [] # You can set a default value if needed
}

variable "data_subnets" {
  description = "List of Data subnet IDs"
  type        = list(string)
  default     = [] # You can set a default value if needed
}

variable "db_name" {
  default = "mydb"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "StrongPassword123!"
}
