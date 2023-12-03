terraform {
  experiments = [module_variable_optional_attrs]
}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge({
    Name = "${var.system_name}-vpc-${random_integer.random.id}"
  }, var.tags)
  lifecycle {
    # because i want to keep aws_internet_gateway and not making it recreated when vpc is recreated
    create_before_destroy = true
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets[count.index].cidr
  availability_zone       = var.public_subnets[count.index].az
  map_public_ip_on_launch = true
  tags = merge({
    Name = "${var.system_name}-subnet-public-${count.index + 1}"
  }, var.public_subnets[count.index].tags)
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.system_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
  tags = {
    Name = "${var.system_name}-route-table-public"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets[count.index].cidr
  availability_zone = var.private_subnets[count.index].az
  tags = merge({
    Name = "${var.system_name}-subnet-private-${count.index + 1}"
  }, var.private_subnets[count.index].tags)
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  # aws automatically create a local route to communicate inside all subnet in a vpc
  # which is equivalent to
  # route {
  #   cidr_block = "10.1.0.0/16"
  #   gateway_id = "local"
  # }
  tags = {
    Name = "${var.system_name}-route-table-private"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id
}
