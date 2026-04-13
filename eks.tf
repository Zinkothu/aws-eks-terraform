# eks_cluster.tf

# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = "1.33"

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    security_group_ids      = [aws_security_group.control_plane.id]
    subnet_ids = [
      aws_subnet.public_ap_southeast_1a.id,
      aws_subnet.public_ap_southeast_1b.id,
      aws_subnet.public_ap_southeast_1c.id,
      aws_subnet.private_ap_southeast_1a.id,
      aws_subnet.private_ap_southeast_1b.id,
      aws_subnet.private_ap_southeast_1c.id
    ]
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  enabled_cluster_log_types = []

  tags = {
    Name = "${var.cluster_name}-control-plane"
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController
  ]
}

# Launch Template for Node Group
resource "aws_launch_template" "node_group" {
  name_prefix = "${var.cluster_name}-node-group-lt"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      iops        = 3000
      throughput  = 125
      volume_size = 80
      volume_type = "gp3"
    }
  }

  metadata_options {
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name                             = "${var.cluster_name}-ng-f9fdb72b-Node"
      "alpha.eksctl.io/nodegroup-type" = "managed"
      "alpha.eksctl.io/nodegroup-name" = "ng-f9fdb72b"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name                             = "${var.cluster_name}-ng-f9fdb72b-Node"
      "alpha.eksctl.io/nodegroup-type" = "managed"
      "alpha.eksctl.io/nodegroup-name" = "ng-f9fdb72b"
    }
  }

  tag_specifications {
    resource_type = "network-interface"
    tags = {
      Name                             = "${var.cluster_name}-ng-f9fdb72b-Node"
      "alpha.eksctl.io/nodegroup-type" = "managed"
      "alpha.eksctl.io/nodegroup-name" = "ng-f9fdb72b"
    }
  }
}

# Managed Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "ng-f9fdb72b"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids = [
    aws_subnet.private_ap_southeast_1a.id,
    aws_subnet.private_ap_southeast_1b.id,
    aws_subnet.private_ap_southeast_1c.id
  ]

  ami_type       = "AL2023_x86_64_STANDARD"
  instance_types = ["t3.medium"]

  launch_template {
    id      = aws_launch_template.node_group.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  labels = {
    "alpha.eksctl.io/cluster-name"   = var.cluster_name
    "alpha.eksctl.io/nodegroup-name" = "ng-f9fdb72b"
  }
  #tag for the node group, which will be applied to all resources created by the node group (EC2 instances, EBS volumes, and ENIs)
  tags = {
    "alpha.eksctl.io/nodegroup-name" = "ng-f9fdb72b"
    "alpha.eksctl.io/nodegroup-type" = "managed"
  }
  #dependency to ensure node group is created after the necessary IAM policies are attached to the node role
  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryPullOnly,
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonSSMManagedInstanceCore
  ]
}