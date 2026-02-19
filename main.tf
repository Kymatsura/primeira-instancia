terraform {
 required_providers {
  aws = {
   source = "hashicorp/aws"
   version = "~> 5.0"
   }
 }
}

provider "aws" {
 region = "us-east-2"
}

#1. Busca a AMI do Amazon Linux 2 mais recente
data "aws_ami" "amazon_linux" {
 most_recent = true
 owners      = ["amazon"]

filter {
 name = "name"
 values = ["amzn2-ami-hvm-*-x86_64-gp2"]
 }
}

#2. Cria um Security Group  (O Firewall da AWS)
resource "aws_security_group" "permitir_ssh" {
 name        = "permitir_ssh"
 description = "Permite acesso SSH vindo de qualquer lugar (para estudos)"

 ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # Em producao, coloque IP real aqui
 }

 egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
 }
# 3. Cria a Instancia EC2
 resource "aws_instance" "servidor_teste" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.permitir_ssh.id]

  tags = {
   Name = "MeuServidorRockyLinux"
   Env  = "Estudos"
  }
 }

 # 4. Saída: Mostra o IP Público no terminal ao final

output "ip_publico" {
 value = aws_instance.servidor_teste.public_ip
}
