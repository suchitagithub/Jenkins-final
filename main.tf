provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "jenkins" {
    ami = "ami-04a81a99f5ec58529"
    instance_type = "t2.micro"
    key_name = "NNnn"
    vpc_security_group_ids = [aws_security_group.Terraform SS.id]
    tags = {
        Name = "Jenkins"
    }
}
resource "aws_instance" "nexus" {
  ami           = "ami-04a81a99f5ec58529"  # Replace with your AMI ID
  instance_type = "t2.medium"
  key_name      = "NNnn"
  vpc_security_group_ids = [aws_security_group.Terraform.id]
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "Terraform-nexus"
  }
}

resource "aws_instance" "Kuberneteves" {
  ami           = "ami-04a81a99f5ec58529"  # Replace with your AMI ID
  instance_type = "t3.medium"
  key_name      = "NNnn"
  vpc_security_group_ids = [aws_security_group.Terraform-prometheus.id]
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "Kuberneteves"
  }

}



resource "aws_security_group" "Terraform SS" {
  name        = "Terraform SS"
  description = "Web Security Group for HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform SS"
  }
}

resource "aws_security_group" "Terraform" {
  name        = "Terraform"
  description = "Jenkins and security group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}


resource "aws_security_group" "Terraform-prometheus" {
  name        = "Terraform-prometheus"
  description = "Jenkins and security group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prometheus-sg"
  }
}
