resource "aws_vpc" "Amar-lms" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Amar"
  }
}
resource "aws_subnet" "Amr.web" {
  vpc_id     = aws_vpc.Amar.lms.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "websubnet"
  }
}
resource "aws_subnet" "Amr.api" {
  vpc_id     = aws_vpc.Amar.lms.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "apisubnet"
  }
}
resource "aws_subnet" "Amr.db" {
  vpc_id     = aws_vpc.Amar.lms.id
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "dbsubnet"
  }
}
# Internet Gateway
resource "aws_internet_gateway"Amar-igv" {
  vpc_id = aws_vpc.Amar-lms.id

  tags = {
    Name = "lms-internet-gateway"
  }}
