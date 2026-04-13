# outputs.tf

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.main.name
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.main.arn
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group ID"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value = [
    aws_subnet.public_ap_southeast_1a.id,
    aws_subnet.public_ap_southeast_1b.id,
    aws_subnet.public_ap_southeast_1c.id
  ]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value = [
    aws_subnet.private_ap_southeast_1a.id,
    aws_subnet.private_ap_southeast_1b.id,
    aws_subnet.private_ap_southeast_1c.id
  ]
}

output "node_instance_role_arn" {
  description = "ARN of the node instance role"
  value       = aws_iam_role.node.arn
}

output "cluster_security_group_id" {
  description = "Security group ID for the cluster"
  value       = aws_security_group.control_plane.id
}

output "shared_node_security_group_id" {
  description = "Shared node security group ID"
  value       = aws_security_group.cluster_shared_node.id
}