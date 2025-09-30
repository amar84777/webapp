resource "aws_vpc" "Amar-lms" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Amar"
  }
}
resource "aws_subnet" "Amr-web" {
  vpc_id     = aws_vpc.Amar-lms.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "websubnet"
  }
}
resource "aws_subnet" "Amr-api" {
  vpc_id     = aws_vpc.Amar-lms.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "apisubnet"
  }
}
resource "aws_subnet" "Amr-db" {
  vpc_id     = aws_vpc.Amar-lms.id
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "dbsubnet"
  }
}
# Internet Gateway
resource "aws_internet_gateway" "Amar_igw" {
  vpc_id = aws_vpc.Amar-lms.id

  tags = {
    Name = "Amar-internet"
  }}


# Public Route Table
resource "aws_route_table" "Amar-pub" {
  vpc_id = aws_vpc.Amar-lms.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Amar_igw.id
  }

  tags = {
    Name = "Amar-public"
  }
}
# Public Route Table Association - Web Subnet
resource "aws_route_table_association" "Amar-public-ass-web" {
  subnet_id      = aws_subnet.Amr-web.id
  route_table_id = aws_route_table.Amar-public.id
}

# Public Route Table Association - API Subnet
resource "aws_route_table_association" "Amar-public-ass-api" {
  subnet_id      = aws_subnet.Amr-api.id
  route_table_id = aws_route_table.Amar-public.id
}

