provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "first_server" {
  ami           = "ami-01e24c3b80b2f5882"
  instance_type = "t2.micro"
  tags = {
    name = "first_server_via_terraform"
  }
}
