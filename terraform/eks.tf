module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-cluster"
  cluster_version = "1.21"
  subnets         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  vpc_id          = aws_vpc.main_vpc.id

  node_groups = {
    eks_nodes = {
      desired_capacity = var.eks_node_desired_capacity
      max_capacity     = var.eks_node_max_capacity
      min_capacity     = var.eks_node_min_capacity
      instance_type    = var.eks_node_instance_type
      key_name         = var.aws_keypair_name
      subnet_ids       = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    }
  }

  node_group_security_group_ids = [aws_security_group.allow_http_https.id]
}
