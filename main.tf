provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "my_project_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "My-Project-VPC"
  }
}

resource "aws_subnet" "my_project_subnet" {
  vpc_id            = aws_vpc.my_project_vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "My-Project-Subnet"
  }
}

resource "aws_internet_gateway" "my_project_igw" {
  vpc_id = aws_vpc.my_project_vpc.id

  tags = {
    Name = "My-Project-IGW"
  }
}

resource "aws_route_table" "my_project_route_table" {
  vpc_id = aws_vpc.my_project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_project_igw.id
  }

  tags = {
    Name = "My-Project-Route-Table"
  }
}

resource "aws_route_table_association" "my_project_route_table_association" {
  subnet_id      = aws_subnet.my_project_subnet.id
  route_table_id = aws_route_table.my_project_route_table.id
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Security group for Jenkins server"
  vpc_id      = aws_vpc.my_project_vpc.id

  ingress {
    description      = "Allow SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTP access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTP Alt access"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Jenkins-Security-Group"
  }
}

resource "aws_security_group" "nexus_sg" {
  name        = "nexus_sg"
  description = "Security group for Nexus server"
  vpc_id      = aws_vpc.my_project_vpc.id

  ingress {
    description      = "Allow SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTP access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTP Alt access"
    from_port        = 8081
    to_port          = 8081
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Nexus-Security-Group"
  }
}

resource "aws_security_group" "microk8s_sg" {
  name        = "microk8s_sg"
  description = "Security group for MicroK8s cluster"
  vpc_id      = aws_vpc.my_project_vpc.id

  ingress {
    description      = "Allow all TCP traffic"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "MicroK8s-Security-Group"
  }
}

resource "aws_instance" "jenkins_instance" {
  ami                      = var.ami_id
  instance_type            = "t2.medium"
  availability_zone        = var.availability_zone
  associate_public_ip_address = true
  vpc_security_group_ids   = [aws_security_group.jenkins_sg.id]
  subnet_id                = aws_subnet.my_project_subnet.id
  key_name                 = var.key_name

  tags = {
    Name = "Jenkins-Instance"
  }
}

resource "aws_instance" "nexus_instance" {
  ami                      = var.ami_id
  instance_type            = "t2.medium"
  availability_zone        = var.availability_zone
  associate_public_ip_address = true
  vpc_security_group_ids   = [aws_security_group.nexus_sg.id]
  subnet_id                = aws_subnet.my_project_subnet.id
  key_name                 = var.key_name

  tags = {
    Name = "Nexus-Instance"
  }
}

resource "aws_instance" "microk8s_instance" {
  ami                      = var.ami_id
  instance_type            = "t3.medium"
  availability_zone        = var.availability_zone
  associate_public_ip_address = true
  vpc_security_group_ids   = [aws_security_group.microk8s_sg.id]
  subnet_id                = aws_subnet.my_project_subnet.id
  key_name                 = var.key_name

  tags = {
    Name = "MicroK8s-Instance"
  }
}
