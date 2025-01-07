output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "eks_cluster_name" {
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_kubeconfig" {
  value = module.eks.cluster_kubeconfig
}
