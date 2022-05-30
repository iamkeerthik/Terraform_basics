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
  key_name               = "aws_key"         //already created through console
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_sg.id]
  subnet_id              = "subnet-0dcb2704139224b6a" //Default subnet id

  //To install http server using provisioner
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("/home/keerthik/keys/aws_key")
    timeout     = "4m"

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

resource "aws_key_pair" "deployer" {
  key_name = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDASb6jODmLgi/VyCJ5kygETuAePZL99itoru1lbImGBZYl6jSrU49Eo1Pq2xfZzyOFg6XiwTscthC61w3P9QO7u+ogX2vAs1PYLbsOo6LOtWbGtf8L6tOEaJsWlKVZg140msZA+I5TvvFxmvZqRumxBQB2Fotv5sWu0pJhrlwcjIuzz0D3QE6gc73xzl03iMOiGrlZ9IK1OISc0WMF4+K9ZzhSXREOTWH212Y++WvO6sZXzhCdwoB2VA26ZbWPEcjcgTiXzUX6aMIeL+CnHaB4vtMwKXXrdc+SN7Ug9C0J6fM+2q4EKF5LQ9f9ywT6/Y0Yu1Khxn9l8Il/eCVmtK83 keerthik@pop-os"
  
}


