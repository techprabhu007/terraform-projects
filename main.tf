# 1. Create a VPC
resource "aws_vpc" "main" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
}
# 2. Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}
# 3. Create a Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true # Key for a public subnet
}
# 4. Create a Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2a"
}
# 5. Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}
# 6. Create the NAT Gateway itself in the PUBLIC subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
}
# 7. Create a Route Table for the public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  # Route traffic destined for the internet to the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
# 8. Create a Route Table for the private subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  # Route traffic to the NAT Gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}
# 9. Create Route Table Associations public
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}
# 10. Create Route Table Associations private
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
# 8. Create a Security Group
resource "aws_security_group" "allow_web" {
  name        = "allow-web-traffic"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # WARNING: Restrict to your IP in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}