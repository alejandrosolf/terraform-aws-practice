variable "aws_region" {
  type        = string
  description = "Region for thw AWS deployment."
}

variable "aws_availability_zone" {
  type        = string
  description = "Availability Zone within selected Region."
}

variable "vpc_cidr_block" {
  type        = string
  description = "Cidr_block for the VPC."
}

variable "vpc_instance_tenancy" {
  type        = string
  description = "Instance tenancy for the VPC."
}

variable "vpc_tags" {
  type        = map(string)
  description = "Tags for the VPC."
}

variable "instance_ami" {
  type        = string
  description = "AMI for the instances"
}

variable "instance_type" {
  type        = string
  description = "Type for the instances"
}

variable "public_subnet_cidr_block" {
  type        = string
  description = "Cidr_block for the public Subnet."
}

variable "public_subnet_tags" {
  type        = map(string)
  description = "Tags of the public Subnet."
}

variable "private_subnet_cidr_block" {
  type        = string
  description = "Cidr_block for the private Subnet."
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Tags of the private Subnet."
}

variable "igw_tags" {
  type        = map(string)
  description = "Tags of the internet gateway."
}

variable "public_route_table_tags" {
  type        = map(string)
  description = "Tags for public subnet route table"
}

variable "clb_sg_tags" {
  type        = map(string)
  description = "Tags for CLB security group"
}

variable "instances_sg_tags" {
  type        = map(string)
  description = "Tags for EC2 instances security group"
}

variable "clb_tags" {
  type        = map(string)
  description = "Tags for load balancer"
}
