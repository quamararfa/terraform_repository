resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "mysubnet" {
 vpc_id     = aws_vpc.myvpc.id
 cidr_block = "10.0.1.0/24"
 map_public_ip_on_launch = "true"  
}

resource "aws_internet_gateway" "mygw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "myroutetable" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mygw.id
    }
  }

resource "aws_route_table_association" "routeassociation" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myroutetable.id
}

resource "aws_security_group" "sg" {
   name        = "web-sg"
   description = "Allow TLS inbound traffic"
   vpc_id      = aws_vpc.myvpc.id
  
   ingress {
     from_port   = 443
     to_port     = 443
     protocol    = "tcp"
     }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    }
  }

resource "aws_key_pair" "deployer" {
  key_name   = "myec2instance"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCeHjb8BX4cXgOg33WkmBZg2+D7g9Qw4lc0b5I2udQI/RBNvl9nvRJQm3fb7nMN6il1jgQYFcNPAsefuoxlc6EITU4C+Agb4Oa330TGOb+sv7AioSPPkMHuODFsYXXnRZ5mRpIvI2ycupV6sGbXkXuQaP+hDlIvaRWZQn2krR1cJh+MV5aNinuHPxyogxL+EldYRqxJbpJMhW9lSToxqO0yGU/nzv89p8u6x34m9QLmOo3Ahl9qzHZ3WFwT02gfdeo4X2ibfN5DTCmfbslge+bWPqmgRoBAYkECOnRA3uHTK/VZAd/SQNv8ETs3zzLd2O3dFEW6kRuG8sox4jjVlq/7 myec2instance"
}

resource "aws_instance" "ec2" {
  subnet_id = aws_subnet.mysubnet.id
  key_name = "myec2instance"
  instance_type = "t2.micro"
  ami = "ami-0518bb0e75d3619ca"
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]
}

