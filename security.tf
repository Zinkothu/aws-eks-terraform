# security_groups.tf

# Control Plane Security Group
resource "aws_security_group" "control_plane" {
  name        = "${var.cluster_name}-control-plane-sg"
  description = "Communication between the control plane and worker nodegroups"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-control-plane-security-group"
  }
}

# Cluster Shared Node Security Group
resource "aws_security_group" "cluster_shared_node" {
  name        = "${var.cluster_name}-cluster-shared-node-sg"
  description = "Communication between all nodes in the cluster"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-cluster-shared-node-security-group"
  }
}

# Security Group Rules
resource "aws_security_group_rule" "control_plane_to_node" {
  description              = "Allow managed and unmanaged nodes to communicate with each other (all ports)"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = aws_security_group.control_plane.id
  security_group_id        = aws_security_group.cluster_shared_node.id
}

resource "aws_security_group_rule" "node_to_control_plane" {
  description              = "Allow unmanaged nodes to communicate with control plane (all ports)"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = aws_security_group.cluster_shared_node.id
  security_group_id        = aws_security_group.control_plane.id
}

resource "aws_security_group_rule" "inter_node_group" {
  description              = "Allow nodes to communicate with each other (all ports)"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = aws_security_group.cluster_shared_node.id
  security_group_id        = aws_security_group.cluster_shared_node.id
}