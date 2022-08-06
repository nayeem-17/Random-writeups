# create a vpc
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tf-dev-vpc"
  }
}

#  create a subnet
resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "dev-subnet-1"
  }
}

# create internet gateway
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id
}

# create a route table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.dev-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }
}

# associate subnet with route table 
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.route_table.id
}

#  create security group
resource "aws_security_group" "dev-sg" {
  name        = "dev-security-group"
  description = "Allowing inbound/outbound traffic"
  vpc_id      = aws_vpc.dev-vpc.id
  ingress {
    description = "Allow inbound SSH traffic "
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow inbound HTTP traffic "
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow inbound HTTPS traffic "
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "Dev Security group"
  }
}

# create an EC2 instance
resource "aws_instance" "main_server" {
  ami                         = "ami-00399ec92321828f5"
  instance_type               = "t2.micro"
  availability_zone           = "us-east-2a"
  key_name                    = "aws-test"
  subnet_id                   = aws_subnet.subnet-1.id
  vpc_security_group_ids      = [aws_security_group.dev-sg.id]
  associate_public_ip_address = true
  user_data                   = file("setup.sh")
  tags = {
    "Name" = "Main Server"
  }
}
