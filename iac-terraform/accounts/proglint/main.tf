# Versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.89.0"
    }
  }
}

# Providers 
provider "aws" {
  # Configuration options
  profile = "proglint"
  region  = "ap-south-2"
}

# Stat File
terraform {
  backend "s3" {
    bucket  = "proglint-iac-terraform-statefiles"
    key     = "core-infra-terraform.tfstate"
    region  = "ap-south-2"
    profile = "iac-terraform-automation"
  }
}

# Versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.89.0"
    }
  }
}

# Providers 
provider "aws" {
  Configuration options
  profile = "proglint"
  region  = "ap-south-2"
}

# Stat File
terraform {
  backend "s3" {
    bucket  = "proglint-iac-terraform-statefiles"
    key     = "core-infra-terraform.tfstate"
    region  = "ap-south-2"
    profile = "iac-terraform-automation"
  }
}


# Create a VPC in AWS part of region i.e. MU 
resource "aws_vpc" "proglint_preprod_vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name       = "proglint_preprod"
    Created_By = "Terraform"
  }
}

output "vpc_id" {
  value = aws_vpc.proglint_preprod_vpc.id
}


Create a Public-Subnet1 part of proglint_preprod_vpc 
resource "aws_subnet" "proglint_preprod_public_subnet_1" {
  vpc_id                  = aws_vpc.proglint_preprod_vpc.id
  cidr_block              = "10.0.1.0/28"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-2a"

  tags = {
    Name       = "proglint_preprod_public_subnet-1"
    created_by = "Terraform"
  }
}

output "public_subnet_1" {
  value = aws_subnet.proglint_preprod_public_subnet_1.id
}

resource "aws_subnet" "proglint_preprod_public_subnet_2" {
  vpc_id                  = aws_vpc.proglint_preprod_vpc.id
  cidr_block              = "10.0.2.0/28"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-2b"

  tags = {
    Name       = "proglint_preprod_public_subnet-2"
    created_by = "Terraform"
  }
}

output "public_subnet_2" {
  value = aws_subnet.proglint_preprod_public_subnet_2.id
}

resource "aws_subnet" "proglint_preprod_private_subnet_1" {
  vpc_id            = aws_vpc.proglint_preprod_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-2a"

  tags = {
    Name       = "proglint_preprod_private_subnet-1"
    created_by = "Terraform"
  }
}

output "private_subnet_1" {
  value = aws_subnet.proglint_preprod_private_subnet_1.id
}

resource "aws_subnet" "proglint_preprod_private_subnet_2" {
  vpc_id            = aws_vpc.proglint_preprod_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-2b"

  tags = {
    Name       = "proglint_preprod_private_subnet-2"
    created_by = "Terraform"
  }
}

output "private_subnet_2" {
  value = aws_subnet.proglint_preprod_private_subnet_2.id
}


resource "aws_subnet" "proglint_preprod_data_subnet_1" {
  vpc_id            = aws_vpc.proglint_preprod_vpc.id
  cidr_block        = "10.0.5.0/28"
  availability_zone = "ap-south-2a"

  tags = {
    Name       = "proglint_preprod_data_subnet-1"
    created_by = "Terraform"
  }
}

output "data_subnet_1" {
  value = aws_subnet.proglint_preprod_data_subnet_1.id
}

resource "aws_subnet" "proglint_preprod_data_subnet_2" {
  vpc_id            = aws_vpc.proglint_preprod_vpc.id
  cidr_block        = "10.0.6.0/28"
  availability_zone = "ap-south-2b"

  tags = {
    Name       = "proglint_preprod_data_subnet-2"
    created_by = "Terraform"
  }
}

output "data_subnet_2" {
  value = aws_subnet.proglint_preprod_data_subnet_2.id
}

# IGW
resource "aws_internet_gateway" "proglint_preprod_igw" {
  vpc_id = aws_vpc.proglint_preprod_vpc.id

  tags = {
    Name       = "proglint_preprod_igw"
    Created_By = "Terraform"
  }
}

output "internet_gw" {
  value = aws_internet_gateway.proglint_preprod_igw.id
}

# RTB
resource "aws_route_table" "proglint_preprod_rtb_public" {
  vpc_id = aws_vpc.proglint_preprod_vpc.id

  tags = {
    Name       = "proglint_preprod_rtb_public"
    Created_By = "Teerraform"
  }
}
resource "aws_route_table" "proglint_preprod_rtb_private" {
  vpc_id = aws_vpc.proglint_preprod_vpc.id

  tags = {
    Name       = "proglint_preprod_rtb_private"
    Created_By = "Teerraform"
  }
}

# Create the internet Access 
resource "aws_route" "proglint_preprod_rtb_igw" {
  route_table_id         = aws_route_table.proglint_preprod_rtb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.proglint_preprod_igw.id

}

#Elastic Ipaddress for NAT Gateway
resource "aws_eip" "proglint_preprod_eip" {
  domain = "vpc"
}

# Create Nat Gateway 
resource "aws_nat_gateway" "proglint_preprod_gw" {
  allocation_id = aws_eip.proglint_preprod_eip.id
  subnet_id     = aws_subnet.proglint_preprod_public_subnet_1.id

  tags = {
    Name      = "Nat Gateway"
    Createdby = "Terraform"
  }
}

output "nat_igw" {
  value = aws_nat_gateway.proglint_preprod_gw.id
}

resource "aws_route_table_association" "proglint_preprod_subnet_association1" {
  subnet_id      = aws_subnet.proglint_preprod_public_subnet_1.id
  route_table_id = aws_route_table.proglint_preprod_rtb_public.id
}
resource "aws_route_table_association" "proglint_preprod_subnet_association2" {
  subnet_id      = aws_subnet.proglint_preprod_public_subnet_2.id
  route_table_id = aws_route_table.proglint_preprod_rtb_public.id
}
resource "aws_route_table_association" "proglint_preprod_subnet_association3" {
  subnet_id      = aws_subnet.proglint_preprod_private_subnet_1.id
  route_table_id = aws_route_table.proglint_preprod_rtb_private.id
}
resource "aws_route_table_association" "proglint_preprod_subnet_association4" {
  subnet_id      = aws_subnet.proglint_preprod_private_subnet_2.id
  route_table_id = aws_route_table.proglint_preprod_rtb_private.id
}
resource "aws_route_table_association" "proglint_preprod_subnet_association5" {
  subnet_id      = aws_subnet.proglint_preprod_data_subnet_1.id
  route_table_id = aws_route_table.proglint_preprod_rtb_private.id
}
resource "aws_route_table_association" "proglint_preprod_subnet_association6" {
  subnet_id      = aws_subnet.proglint_preprod_data_subnet_2.id
  route_table_id = aws_route_table.proglint_preprod_rtb_private.id
}

# Allow internet access from NAT Gateway to Private Route Table
resource "aws_route" "proglint_preprod_rtb_private_gw" {
  route_table_id         = aws_route_table.proglint_preprod_rtb_private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.proglint_preprod_gw.id
}

# Network Access Control List 
resource "aws_network_acl" "proglint_preprod_nsg" {
  vpc_id = aws_vpc.proglint_preprod_vpc.id
  subnet_ids = [
    "${aws_subnet.proglint_preprod_public_subnet_1.id}",
    "${aws_subnet.proglint_preprod_public_subnet_2.id}",
    "${aws_subnet.proglint_preprod_private_subnet_1.id}",
    "${aws_subnet.proglint_preprod_private_subnet_2.id}",
    "${aws_subnet.proglint_preprod_data_subnet_1.id}",
    "${aws_subnet.proglint_preprod_data_subnet_2.id}"
  ]

  Allow ingress of ports from 1024 to 65535
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  Allow egress of ports from 1024 to 65535
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name      = "proglint_preprod_nsg"
    createdby = "Terraform"
  }
}

output "nacl" {
  value = aws_network_acl.proglint_preprod_nsg.id
}

# EC2 instance Security group
resource "aws_security_group" "proglint_preprod_linux_sg" {
  vpc_id      = aws_vpc.proglint_preprod_vpc.id
  name        = "proglint_preprod_linux_sg"
  description = "To Allow SSH From IPV4 Devices"

  Allow Ingress / inbound Of port 22 
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  Allow egress / outbound of all ports 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "proglint_preprod_sg_linux"
    Description = "proglint_preprod allow SSH"
    createdby   = "terraform"
  }

}

output "linux_sg" {
  value = aws_security_group.proglint_preprod_linux_sg.id
}


# EC2 instance Security group
resource "aws_security_group" "proglint_preprod_windows_sg" {
  vpc_id      = aws_vpc.proglint_preprod_vpc.id
  name        = "proglint_preprod_windows_sg"
  description = "To Allow RDP From IPV4 Devices"

  Allow Ingress / inbound Of port 3389
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
  }
  Allow egress / outbound of all ports 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sg_proglint_preprod_windows"
    Description = "proglint_preprod allow RDP"
    createdby   = "terraform"
  }

}

output "windows_sg" {
  value = aws_security_group.proglint_preprod_windows_sg.id
}

# EC2 instance Security group
resource "aws_security_group" "proglint_preprod_web_sg" {
  vpc_id      = aws_vpc.proglint_preprod_vpc.id
  name        = "proglint_preprod_web_sg"
  description = "To Allow SSH From IPV4 Devices"

  Allow Ingress / inbound Of port 22 
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  Allow Ingress / inbound Of port 80 
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  Allow Ingress / inbound Of port 8080 
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
  }
  Allow egress / outbound of all ports 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "proglint_preprod_sg"
    Description = "proglint_preprod allow SSH - RDP - HTTP and Jenkins"
    createdby   = "terraform"
  }

}

output "web_sg" {
  value = aws_security_group.proglint_preprod_web_sg.id
}


