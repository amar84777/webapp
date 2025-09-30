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
# FROM HERE NEW
# Private Route Table
resource "aws_route_table" "Amar-private" {
  vpc_id = aws_vpc.Amar-vpc.id

  tags = {
    Name = "Amar-private"
  }
}

# Private Route Table Association - Database Subnet
resource "aws_route_table_association" "Amar-private-ass" {
  subnet_id      = aws_subnet.Amr.db.id
  route_table_id = aws_route_table.Amar-private.id
}

# NACL - Web Subnet
resource "aws_network_acl" "Amar-nacl" {
  vpc_id = aws_vpc.Amar-lms.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "Amar-web-nacl"
  }
}

# NACL - Web Subnet Association
resource "aws_network_acl_association" "Amar-web-nacl-asc" {
  network_acl_id = aws_network_acl.Amar-web-nacl.id
  subnet_id      = aws_subnet.lms-Amr-web.id
}

# NACL - API Subnet
resource "aws_network_acl" "Amr-api-nacl" {
  vpc_id = aws_vpc.Amar-lms.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "Amr-api-nacl"
  }
}

# NACL - API Subnet Association
resource "aws_network_acl_association" "Amr-api-nacl-asc" {
  network_acl_id = aws_network_acl.Amr-api-nacl.id
  subnet_id      = aws_subnet.Amr-api.id
}

# NACL - DB Subnet
resource "aws_network_acl" "Amr-db-nacl" {
  vpc_id = aws_vpc.Amar-lms.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "Amr-db-nacl"
  }
}

# NACL - DB Subnet Association
resource "aws_network_acl_association" "Amr-db-nacl-asc" {
  network_acl_id = aws_network_acl.Amr-db-nacl.id
  subnet_id      = aws_subnet.Amr-db.id
}

# Security Group - Web
resource "aws_security_group" "Amar-web-sg" {
  name        = "Amar-web"
  description = "Allow WEB Traffic"
  vpc_id      = aws_vpc.Amar-lms.id

  tags = {
    Name = "Amar-web-sg"
  }
}

# Security Group Rule - SSH
resource "aws_vpc_security_group_ingress_rule" "Amar-web-sg-ssh" {
  security_group_id = aws_security_group.Amar-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Security Group Rule - HTTP
resource "aws_vpc_security_group_ingress_rule" "Amar-web-sg-http" {
  security_group_id = aws_security_group.Amar-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Security Group Rule - Egress (outbound)
resource "aws_vpc_security_group_egress_rule" "Amar-web-sg-egress" {
  security_group_id = aws_security_group.Amar-web-sg.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65535
}

# Security Group - API
resource "aws_security_group" "Amar-api-sg" {
  name        = "Amar-api"
  description = "Allow API Traffic"
  vpc_id      = aws_vpc.Amar-vpc.id

  tags = {
    Name = "Amar-api-sg"
  }
}

# Security Group Rule - SSH
resource "aws_vpc_security_group_ingress_rule" "Amar-api-sg-ssh" {
  security_group_id = aws_security_group.Amar-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Security Group Rule - HTTP
resource "aws_vpc_security_group_ingress_rule" "Amar-api-sg-http" {
  security_group_id = aws_security_group.Amar-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

# Security Group Rule - Egress (outbound)
resource "aws_vpc_security_group_egress_rule" "Amar-api-sg-egress" {
  security_group_id = aws_security_group.Amar-api-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65535
}

# Security Group - DB
resource "aws_security_group" "Amar-db-sg" {
  name        = "lms-db"
  description = "Allow DB Traffic"
  vpc_id      = aws_vpc.Amar-lms.id

  tags = {
    Name = "Amar-db-sg"
  }
}

# Security Group Rule - SSH
resource "aws_vpc_security_group_ingress_rule" "Amar-db-sg-ssh" {
  security_group_id = aws_security_group.Amar-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Security Group Rule - POSTGRES
resource "aws_vpc_security_group_ingress_rule" "Amar-db-sg-postgres" {
  security_group_id = aws_security_group.Amar-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

# Security Group Rule - Egress (outbound)
resource "aws_vpc_security_group_egress_rule" "Amar-db-sg-egress" {
  security_group_id = aws_security_group.Amar-db-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65535
}

# EC2 Server - Web
resource "aws_instance" "Amar-web-server" {
  ami           = "ami-0c3b809fcf2445b6a"
  instance_type = "t2.micro"
  key_name = "2501"
  subnet_id = aws_subnet.Amar-web-sn.id
  vpc_security_group_ids = [aws_security_group.lms-web-sg.id]
  user_data = file("script.sh")

  tags = {
    Name = "Amar-web-server"
  }
}

