module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Project     = "Terraform-EC2-VPC-Demo"
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = "t2.micro"
  ami                    = var.ami_id # Ubuntu 24.04 LTS AMI in eu-central-1
  monitoring             = false
  subnet_id              = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = [
    aws_security_group.ssh_access_sg.id
  ]

  tags = {
    Project     = "Terraform-EC2-VPC-Demo"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "ssh_access_sg" {
  name        = "ssh-access-for-ec2"
  description = "Allow SSH inbound traffic for EC2 instance"
  vpc_id      = module.vpc.vpc_id # Verknüpft mit der VPC aus dem VPC-Modul

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ACHTUNG: Für Produktionsumgebungen stark einschränken!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Alle Protokolle
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-access-sg"
  }
}