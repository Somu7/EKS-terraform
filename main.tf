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
# creating a internet gatewat

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "project IGW"
  }
  
}

# creating a 2nd Route table
# We already know that when a VPC is created, a main route table is created as well. The main route table is responsible for enabling the flow of traffic within the VPC. 

resource "aws_route_table" "second_rt" {
 vpc_id = aws_vpc.main.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
 
 tags = {
   Name = "2nd Route Table"
 }
}

#  Associating Public Subnets to the Second Route Table
resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.second_rt.id
}
# create an EC2 instance
resource "aws_instance" "eks-master1" {
   ami                    = var.os_name
   instance_type          = var.instance_type
   associate_public_ip_address = true
 # subnet_id              = "${element(aws_subnet.private_subnet.*.id, count.index)}"
 # availability_zone = length(var.availability_zones)
 #  vpc_security_group_ids = sg-03cde4e562a7e79b3
 }

