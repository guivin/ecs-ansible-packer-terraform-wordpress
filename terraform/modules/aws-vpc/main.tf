locals {
  # Nat gateways are used to permit instances to reach out the Internet. It is possible to use a single nat gateway
  # for multiple private subnets for cost-optimization in spite of HA (dev environments are a good fit here)
  nat_gateway_count = var.single_nat_gateway ? 1 : length(var.private_subnet_cidr_blocks)
}

resource "aws_vpc" "default" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = merge({
	Name = "${var.tags["environment"]}-${var.tags["project"]}-vpc"
  }, var.tags)
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags   = merge({
	Name = "${var.tags["environment"]}-${var.tags["project"]}-ig"
  }, var.tags)
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]
  tags              = merge({
	Name = "${var.tags["environment"]}-${var.tags["project"]}-private-subnet-${count.index}"
  }, var.tags)
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidr_blocks)
  vpc_id = aws_vpc.default.id
  tags   = merge({
	Name = "${var.tags["environment"]}-${var.tags["project"]}-private-${count.index}"
  }, var.tags)
}

resource "aws_eip" "nat_gateway" {
  count = local.nat_gateway_count
  vpc   = true
  tags  = merge({
	Name = "${var.tags["environment"]}-${var.tags["project"]}-nat-eip-${count.index}"
  }, var.tags)
}

resource "aws_nat_gateway" "default" {
  count         = local.nat_gateway_count
  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = aws_subnet.private[count.index].id
  tags          = merge({
	Name = "${var.tags["environment"]}-${var.tags["project"]}-nat-gw-${count.index}"
  }, var.tags)
}

resource "aws_route" "nat_gateway" {
  count                  = length(var.private_subnet_cidr_blocks)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = local.nat_gateway_count == 1 ? aws_nat_gateway.default[0].id : aws_nat_gateway.default[count.index].id
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags                    = merge({
	Name = "${var.tags["environment"]}-${var.tags["project"]}-public-subnet-${count.index}"
  }, var.tags)
}

resource "aws_route_table" "public" {
  count  = length(var.private_subnet_cidr_blocks)
  vpc_id = aws_vpc.default.id
  tags   = merge({
	Name = "${var.tags["environment"]}-${var.tags["project"]}-public-rt-${count.index}"
  }, var.tags)
}

resource "aws_main_route_table_association" "public" {
  count          = length(var.public_subnet_cidr_blocks)
  vpc_id         = aws_vpc.default.id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route" "internet_gateway" {
  count                  = length(var.public_subnet_cidr_blocks)
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public[count.index].id
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr_blocks)
  route_table_id = aws_route_table.public[count.index].id
  subnet_id      = aws_subnet.public[count.index].id
}
