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
  vpc_id = aws_default_vpc.default.id //using default vpc id

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

resource "aws_security_group" "elb_sg" {
  name   = "elb_sg"
  vpc_id = aws_default_vpc.default.id //using default vpc id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0  //all ports
    to_port     = 0  //all ports
    protocol    = -1 //all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_elb" "my_elb" {
  name            = "my-elb"
  subnets         = data.aws_subnet_ids.default_subnets.ids
  security_groups = [aws_security_group.elb_sg.id]
  instances       = values(aws_instance.Http_servers).*.id

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


}


resource "aws_instance" "Http_servers" {
  ami                    = data.aws_ami.aws-linux-2-latest.id //use id from data provider to make it dynamic
  key_name               = "terraform-ec2"                    //key is already created through console
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_sg.id]

  for_each  = data.aws_subnet_ids.default_subnets.ids //before apply we have to run -> terraform apply -target=data.aws_subnet_ids.default_subnets
  subnet_id = each.value                              // so subnet list will refresh before using it after that  run -> terraform apply

  tags = {
    "Name" : "Http_servers_${each.value}"
  }


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


