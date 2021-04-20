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
