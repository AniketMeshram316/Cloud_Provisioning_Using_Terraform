# 1. VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "my_vpc"
  }
}

# 2. subnet
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.public_subnet, count.index)

  tags = {
    Name = var.public_names[count.index]
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.private_subnet, count.index)

  tags = {
    Name = var.private_names[count.index]
  }
}

# 3. Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgateway.id
  }

  tags = {
    Name = "private_rt"
  }
}

# 4. Route Table Association
resource "aws_route_table_association" "public_association" {
  count = length(var.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_association" {
  count = length(var.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

# 5. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MyInternetGateway"
  }
}

# 6. Elastic Ip
resource "aws_eip" "nat" {
  domain = "vpc"
}

# 7. Nat Gateway
resource "aws_nat_gateway" "natgateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "MyNatGateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}
