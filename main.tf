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
#  Create a Public Subnet
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-west-2b"
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
#  Create a Route Table for the public subnet
resource "aws_route_table" "public_rt1" {
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
# Create Route Table Associations public1
resource "aws_route_table_association" "public_assoc1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_rt1.id
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
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
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
# 9. Create an EC2 instance in the public subnet
resource "aws_instance" "web_server" {
  ami           = "ami-05f991c49d264708f"
  instance_type = "t2.micro"

  # Place the instance in the first public subnet
  subnet_id = aws_subnet.public.id

  # Attach the security group we created earlier
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  user_data              = (file("userdata.sh"))
  tags = {
    Name = "Terraform-Server-01-Modern"
  }
}

# 10. Create an EC2 instance in the public1 subnet
resource "aws_instance" "app_server" {
  ami           = "ami-05f991c49d264708f"
  instance_type = "t2.micro"

  # Place the instance in the first public1 subnet
  subnet_id = aws_subnet.public1.id

  # Attach the security group we created earlier
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  user_data              = (file("userdata1.sh"))
  tags = {
    Name = "Terraform-Server-02-Cyberpunk"
  }
}
# 10. Security Group for the Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "alb-security-group"
  description = "Allow HTTP traffic to the ALB"
  vpc_id      = aws_vpc.main.id

  # Allow inbound HTTP traffic from anywhere
  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}
# 11. Create Application Load Balancer 
resource "aws_lb" "main_alb" {
  name               = "main-app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  # The ALB needs to be in at least two public subnets for high availability
  subnets = [aws_subnet.public.id, aws_subnet.public1.id]
  tags = {
    Name = "main-alb"
  }
}
# 12. A Target Group for the EC2 instances
resource "aws_lb_target_group" "main_tg" {
  name     = "main-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/"
    port = "traffic-port"
  }

  tags = {
    Name = "main-tg"
  }
}

# 13. A Listener for the Load Balancer
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main_tg.arn
  }
}

# 14. Attach the EC2 instance to the Target Group1
resource "aws_lb_target_group_attachment" "attachment" {
  target_group_arn = aws_lb_target_group.main_tg.arn
  target_id        = aws_instance.web_server.id
  port             = 80
}
# 14. Attach the EC2 instance to the Target Group2
resource "aws_lb_target_group_attachment" "attachment1" {
  target_group_arn = aws_lb_target_group.main_tg.arn
  target_id        = aws_instance.app_server.id
  port             = 80
}