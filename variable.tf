variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for subnet"
  default     = "10.0.1.0/24"
}

variable "ami_id" {
  description = "AMI ID for instances"
  default     = "ami-0497a974f8d5dcef8"
}

variable "availability_zone" {
  description = "Availability zone for subnet"
  default     = "us-east-1a"
}

variable "key_name" {
  description = "Name of the key pair to use for SSH access"
  default     = "NNnn"
}
