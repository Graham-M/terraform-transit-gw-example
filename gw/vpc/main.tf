data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "in" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_in_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.name}-in"
  }
}

resource "aws_subnet" "out" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_out_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.name}-out"
  }
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.name
  }
}

resource "aws_route_table" "out" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.name}-out"
  }
}

resource "aws_route" "out" {
  route_table_id         = aws_route_table.out.id
  destination_cidr_block = var.super_net
  transit_gateway_id     = var.transit_gw_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.main]
}

resource "aws_route_table" "in" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-in"
  }
}

resource "aws_route" "in" {
  route_table_id         = aws_route_table.in.id
  destination_cidr_block = var.super_net
  transit_gateway_id     = var.transit_gw_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.main]
}

resource "aws_route_table_association" "out" {
  subnet_id      = aws_subnet.out.id
  route_table_id = aws_route_table.out.id
}

resource "aws_route_table_association" "in" {
  subnet_id      = aws_subnet.in.id
  route_table_id = aws_route_table.in.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  #count                                           = var.attach_tgw == "True" ? 1 : 0
  transit_gateway_id                              = var.transit_gw_id
  subnet_ids                                      = [aws_subnet.in.id]
  vpc_id                                          = aws_vpc.main.id
  transit_gateway_default_route_table_propagation = true

  tags = {
    Name = var.name
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_in_id" {
  value = aws_subnet.in.id
}

output "subnet_out_id" {
  value = aws_subnet.out.id
}

output "tgw_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.main.*.id
}
