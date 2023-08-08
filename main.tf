terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

# configure the aws provider
provider "aws" {
  region = var.location
}
# create a vpc
resource "aws_vpc" "main"{
    cidr_block = var.vpc_cidr
}
# create a subnets
resource "aws_subnet" "public_subnets" {
 count             = length(var.public_subnet_cidrs)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}
 
resource "aws_subnet" "private_subnets" {
 count             = length(var.private_subnet_cidrs)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}

# create an EC2 instance
resource "aws_instance" "eks-master1" {
   ami                    = var.os_name
   instance_type          = var.instance_type
   associate_public_ip_address = true
 #  subnet_id              = aws_subnet.subnet.id
 #  vpc_security_group_ids = sg-03cde4e562a7e79b3
 }


