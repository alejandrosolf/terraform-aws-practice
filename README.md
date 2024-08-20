# Terraform Project: AWS Infrastructure Setup

This Terraform project automates the creation of a basic AWS infrastructure. The infrastructure consists of a Virtual Private Cloud (VPC), subnets, security groups, EC2 instances, and a Classic Load Balancer (CLB).

## Overview

The following resources will be created:

1. **VPC**: A new Virtual Private Cloud to host the infrastructure.
2. **Internet Gateway**: Allows internet access to resources within the VPC.
3. **Custom Route Table**: Directs traffic between the subnets and the internet.
4. **Public Subnet**: A subnet within the VPC that is accessible from the internet.
5. **Route Table Association**: Associates the public subnet with the custom route table.
6. **Security Groups**:
   - **Instance Security Group**: Allows inbound traffic on port 80 and traffic from the ELB.
   - **ELB Security Group**: Allows inbound traffic on port 80 from the internet.
7. **EC2 Instances**: Two instances with a user data script to demonstrate load balancing.
8. **Classic Load Balancer (CLB)**: Distributes incoming traffic across the EC2 instances.

## Prerequisites

- Terraform installed on your local machine.
- AWS credentials configured for Terraform.

## Important commands

```bash
terraform init
```
```bash
terraform plan --var-file variables.tfvars.json
```
```bash
terraform apply --var-file variables.tfvars.json --auto-approve
```   
```bash
terraform destroy --var-file variables.tfvars.json --auto-approve
```   
