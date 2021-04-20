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
