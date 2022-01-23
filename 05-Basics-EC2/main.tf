terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

variable "aws_key_pair" {
  default = "terraform-ec2.pem"

}

resource "aws_default_vpc" "default" { //using default vpc in us-east-1 region
  
}

resource "aws_security_group" "http_sg" {
  name   = "http_sg"
#   vpc_id = "vpc-08755d377f47a356a" //default vpc id from us-east-1 region
  vpc_id=aws_default_vpc.default.id //using default vpc id

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

  egress {
    from_port   = 0  //all ports
    to_port     = 0  //all ports
    protocol    = -1 //all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "Http-server-sg"
  }
}

resource "aws_instance" "Http_server" {
  ami                    = "ami-08e4e35cccc6189f4" //Amazon linux2
  key_name               = "terraform-ec2"         //already created through console
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_sg.id]
  subnet_id              = "subnet-0dcb2704139224b6a" //Default subnet id

  //To install http server using provisioner
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)

  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo service httpd start",
      "echo  Hello from Terrafrom server ${self.public_dns} | sudo tee /var/www/html/index.html"
    ]

  }
}


