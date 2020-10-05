/*
  Configures a VPC using the terraform-aws-modules/vpc/aws module
  Configures 3 private and 3 public subnets across 3 availability zones
  Tags are implemented so the VPC can be utilized for the EKS cluster
*/
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.app_name}-vpc"
  cidr = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_tags = {
    Terraform                               = "true"
    Environment                             = "${var.app_name}-private-subnet"
    "kubernetes.io/cluster/${var.app_name}" = "shared"
    "i.	kubernetes.io/role/internal-elb"    = "1"
  }

  public_subnets = ["10.0.50.0/24", "10.0.51.0/24", "10.0.52.0/24"]
  public_subnet_tags = {
    Terraform                               = "true"
    Environment                             = "${var.app_name}-public-subnet"
    "kubernetes.io/cluster/${var.app_name}" = "shared"
    "i.	kubernetes.io/role/elb"             = "1"
  }

  enable_nat_gateway = true

  tags = {
    Terraform                               = "true"
    Environment                             = var.app_name
    "kubernetes.io/cluster/${var.app_name}" = "shared"
  }
}