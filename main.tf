resource "aws_ec2_transit_gateway" "main" {
  description = "example"
}

variable "super_net" {
  default = "10.0.0.0/8"
}

module "vpc1" {
  source          = "./vpc"
  name            = "vpc1"
  vpc_cidr        = "10.20.0.0/16"
  subnet_out_cidr = "10.20.0.0/24"
  subnet_in_cidr  = "10.20.1.0/24"
  super_net       = var.super_net
  transit_gw_id   = aws_ec2_transit_gateway.main.id
}

module "vpc2" {
  source          = "./vpc"
  name            = "vpc2"
  vpc_cidr        = "10.30.0.0/16"
  subnet_out_cidr = "10.30.0.0/24"
  subnet_in_cidr  = "10.30.1.0/24"
  super_net       = var.super_net
  transit_gw_id   = aws_ec2_transit_gateway.main.id
}
