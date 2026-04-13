# variables.tf

variable "aws_region" {
  description = "AWS region to deploy the EKS cluster"
  type        = string
  default     = "ap-southeast-1"
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "hc-eks-sgp-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.16.0.0/16"
}

variable "public_ap_southeast_1a_cidr" {
  description = "CIDR block for the public subnet in ap-southeast-1a"
  type        = string
  default     = "172.16.1.0/24"
}

variable "public_ap_southeast_1b_cidr" {
  description = "CIDR block for the public subnet in ap-southeast-1b"
  type        = string
  default     = "172.16.2.0/24"
}

variable "public_ap_southeast_1c_cidr" {
  description = "CIDR block for the public subnet in ap-southeast-1c"
  type        = string
  default     = "172.16.3.0/24"
}


variable "private_ap_southeast_1a_cidr" {
  description = "CIDR block for the private subnet in ap-southeast-1a"
  type        = string
  default     = "172.16.4.0/24"
}

variable "private_ap_southeast_1b_cidr" {
  description = "CIDR block for the private subnet in ap-southeast-1b"
  type        = string
  default     = "172.16.5.0/24"
}

variable "private_ap_southeast_1c_cidr" {
  description = "CIDR block for the private subnet in ap-southeast-1c"
  type        = string
  default     = "172.16.6.0/24"
}

variable "default_route_cidr" {
  description = "CIDR block for the default route (0.0.0.0/0)"
  type        = string
  default     = "0.0.0.0/0"
}