resource "aws_subnet" "in" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_in_cidr

  tags = {
    Name = "${var.name}-in"
  }
}

resource "aws_subnet" "out" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_out_cidr

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

  route {
    cidr_block         = var.super_net
    transit_gateway_id = var.transit_gw_id
  }

  tags = {
    Name = "${var.name}-out"
  }
}

resource "aws_route_table" "in" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block         = var.super_net
    transit_gateway_id = var.transit_gw_id
  }

  tags = {
    Name = "${var.name}-in"
  }
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
  subnet_ids                                      = [aws_subnet.in.id, aws_subnet.out.id]
  transit_gateway_id                              = var.transit_gw_id
  vpc_id                                          = aws_vpc.main.id
  transit_gateway_default_route_table_propagation = true
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


