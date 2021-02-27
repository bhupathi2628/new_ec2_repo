# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Define VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc"
  }
}

# Define the public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "publicsubnet"
    }
}

# Define the internet gateway
resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "myigw"
  }
}

# Define the route table public
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

# public subnet association
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

## Security Group##
resource "aws_security_group" "terraform_private_sg" {
  description = "Allow limited inbound external traffic"
  vpc_id      = aws_vpc.my_vpc.id
  name        = "terraform_ec2_private_sg"

  ingress {
    protocol    = -1
    cidr_blocks = ["49.207.59.98/32"]
    from_port   = 0
    to_port     = 0
  }

  egress {
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  tags = {
    Name = "ec2-private-sg"
  }
}

# generate key
resource "aws_key_pair" "ec2key" {
  key_name   = "nithunavi"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA5racYqr+q7fQESfern8JC6KPooOLyUtMoFCTDzD0y2rVEGHM9PfGG6EbTYAQi74Pqxc8J7Cuhg3lj8Z2sVHhC5PGq+VLYcMu9gBPw2ODcy6YDWaoS4HCEUgZz/SpCgasJt7KPvTJYOMt/uyEP2aMWN3GDo3+YK2Z27E6M/feFTtkARkTazto1akTSPEjo0tLhXa3+FgESoRqWTOj1sZb5QuX4Nw49rMNhJZ8mtAyJVu6hj5wLnI5gEBXLgTf9ZzR52grqbsV6ZNUV9NEn++ngMQ4nTg7Er+nJ6EjIIiUhVDievh65NmdT0V3DxticoSiuQDfNkRXXTmTZFBeTdeyBw== rsa-key-20210211"
}

# instance
resource "aws_instance" "amazon" {
  ami                         = "ami-09c5e030f74651050"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.terraform_private_sg.id}"]  
  subnet_id                   = aws_subnet.public_subnet.id
  key_name                    = "nithunavi"
  count                       = 1
  associate_public_ip_address = true
  tags = {
    Name = "amazon_server"
  }
}

resource "aws_ebs_volume" "custom_ebs" {
  availability_zone = "us-west-2a"
  size              = 100
  type = "gp3"
  tags = {
    Name = "new_ebs"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.custom_ebs.id
  instance_id = aws_instance.amazon[0].id
}

resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = aws_ebs_volume.custom_ebs.id

  tags = {
    Name = "new_ebs_snap"
  }
}






































# # Define the elastic ip
# resource "aws_eip" "eip" {
#   vpc = true
# }


# resource "aws_instance" "ubuntu" {
#   ami                         = "ami-025102f49d03bec05"
#   instance_type               = "t2.micro"
#   vpc_security_group_ids      = ["${aws_security_group.terraform_private_sg.id}"] 
#   subnet_id                   = aws_subnet.public_subnet.id
#   key_name                    = "nithunavi"
#   count                       = 1
#   associate_public_ip_address = true
#   tags = {
#     Name = "ubuntu_server"
#   }
# }

# ## Security Group##
# resource "aws_security_group" "terraform_private_security_g" {
#   description = "Allow limited inbound external traffic"
#   vpc_id      = aws_vpc.my_vpc.id
#   name        = "tfec2_private_sg"

#   ingress {
#     protocol    = "tcp"
#     cidr_blocks = ["106.51.104.161/32"]
#     from_port   = 22
#     to_port     = 22
#   }

#   egress {
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 0
#     to_port     = 0
#   }


#   tags = {
#     Name = "ec2-private-sg-2"
#   }
# }