resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.subnet_a_cidr
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.subnet_b_cidr
  availability_zone = "us-west-2b"
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.main_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

resource "aws_route_table_association" "subnet_a_association" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_route_table_association" "subnet_b_association" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.main_route_table.id
}
