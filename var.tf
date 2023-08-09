variable "location" {
    default = "ap-south-1"
  
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}


variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
}

variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
}
variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "os_name" {
  type = string
  default = "ami-0ded8326293d3201b"
}
variable "key_name" {
    default = "proceed without a key pair"
  
}
variable "instance_type" {
  type = string
  default = "t2.micro" 
}
