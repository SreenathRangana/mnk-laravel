# AWS Region
variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-west-2"  # Change to your region
}

# VPC CIDR block
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Subnet CIDR blocks
variable "subnet_a_cidr" {
  description = "The CIDR block for subnet A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_b_cidr" {
  description = "The CIDR block for subnet B"
  type        = string
  default     = "10.0.2.0/24"
}

# EKS Node configuration
variable "eks_node_instance_type" {
  description = "The EC2 instance type for the EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "eks_node_min_capacity" {
  description = "The minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "eks_node_max_capacity" {
  description = "The maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "eks_node_desired_capacity" {
  description = "The desired number of worker nodes"
  type        = number
  default     = 2
}

# IAM Role Name for EKS
variable "eks_cluster_role_name" {
  description = "The IAM role name for the EKS cluster"
  type        = string
  default     = "eks-cluster-role"
}

variable "eks_node_role_name" {
  description = "The IAM role name for the EKS worker nodes"
  type        = string
  default     = "eks-node-role"
}

# AWS Keypair Name for EC2 instances (optional)
variable "aws_keypair_name" {
  description = "The name of the AWS EC2 keypair for SSH access"
  type        = string
  default     = "my-keypair"  # Update with your keypair
}
