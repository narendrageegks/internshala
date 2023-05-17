
# Configure provider (AWS in this case)
provider "aws" {
  region      = "us-west-2"
  access_key = "------------------------------"
  secret_key = "-------------------------------------"
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create subnet
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
}

# Create security group
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  vpc_id = aws_vpc.my_vpc.id
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

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instances
resource "aws_instance" "my_instance1" {
  ami           = "ami-0c94855ba95c71c99"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
}

resource "aws_instance" "my_instance2" {
  ami           = "ami-0c94855ba95c71c99"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
}

# Create load balancer
resource "aws_lb" "my_load_balancer" {
  name               = "my-load-balancer"
  load_balancer_type = "application"
  subnets            = [aws_subnet.my_subnet.id]
  security_groups = [aws_security_group.my_security_group.id]
  tags = {
    Name = "my-load-balancer"
  }
}

# Attach instances to load balancer target group
resource "aws_lb_target_group_attachment" "attachment1" {
  target_group_arn = aws_lb.my_load_balancer.arn
  target_id        = aws_instance.my_instance1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attachment2" {
  target_group_arn = aws_lb.my_load_balancer.arn
  target_id        = aws_instance.my_instance2.id
  port             = 80
}
