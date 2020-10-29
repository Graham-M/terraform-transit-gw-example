data "aws_caller_identity" "apptest0" {
  provider = aws.apptest0
}

data "aws_caller_identity" "apptest1" {
  provider = aws.apptest1
}

data "aws_caller_identity" "apptest2" {
  provider = aws.apptest2
}

resource "aws_ec2_transit_gateway" "main" {
  provider    = aws.apptest0
  description = "CS Transit GW"
}

### Sharing transit GW outwards ###
resource "aws_ram_resource_share" "main" {
  provider = aws.apptest0

  allow_external_principals = true

  name = "CS Transit GW"
  tags = {
    Name = "CS Transit GW"
  }
}

resource "aws_ram_resource_association" "main" {
  provider = aws.apptest0

  resource_arn       = aws_ec2_transit_gateway.main.arn
  resource_share_arn = aws_ram_resource_share.main.id
}

resource "aws_ram_principal_association" "apptest0toapptest1" {
  provider = aws.apptest0

  depends_on = [aws_ram_resource_association.main]

  principal          = data.aws_caller_identity.apptest1.account_id
  resource_share_arn = aws_ram_resource_share.main.id
}

resource "aws_ram_principal_association" "apptest0toapptest2" {
  provider = aws.apptest0

  depends_on = [aws_ram_resource_association.main]

  principal          = data.aws_caller_identity.apptest2.account_id
  resource_share_arn = aws_ram_resource_share.main.id
}

### End Share transit GW ###

### apptest0 - VPC0 ###

#resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "vpc0" {
#provider                      = aws.apptest0
#transit_gateway_attachment_id = module.vpc0.tgw_attachment_id.0
#}

module "vpc0" {
  providers       = { aws = aws.apptest0 }
  source          = "./vpc"
  name            = "vpc0"
  vpc_cidr        = "10.20.0.0/16"
  subnet_out_cidr = "10.20.0.0/24"
  subnet_in_cidr  = "10.20.1.0/24"
  super_net       = var.super_net
  transit_gw_id   = aws_ec2_transit_gateway.main.id
  attach_tgw      = "False"
}

### apptest1 - VPC1 ###
resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "vpc1" {
  provider                      = aws.apptest0
  transit_gateway_attachment_id = module.vpc1.tgw_attachment_id.0
}

#resource "aws_ram_resource_share_accepter" "accept_apptest1" {
#provider  = aws.apptest1
#share_arn = aws_ram_principal_association.apptest0toapptest1.resource_share_arn
#}

module "vpc1" {
  providers       = { aws = aws.apptest1 }
  source          = "./vpc"
  name            = "vpc1"
  vpc_cidr        = "10.30.0.0/16"
  subnet_out_cidr = "10.30.0.0/24"
  subnet_in_cidr  = "10.30.1.0/24"
  super_net       = var.super_net
  transit_gw_id   = aws_ec2_transit_gateway.main.id
}

### apptest2 - VPC2 ###
resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "vpc2" {
  provider                      = aws.apptest0
  transit_gateway_attachment_id = module.vpc2.tgw_attachment_id.0
}

#resource "aws_ram_resource_share_accepter" "accept_apptest2" {
#provider                      = aws.apptest2
#share_arn = aws_ram_principal_association.apptest0toapptest2.resource_share_arn
#}

module "vpc2" {
  providers       = { aws = aws.apptest2 }
  source          = "./vpc"
  name            = "vpc2"
  vpc_cidr        = "10.40.0.0/16"
  subnet_out_cidr = "10.40.0.0/24"
  subnet_in_cidr  = "10.40.1.0/24"
  super_net       = var.super_net
  transit_gw_id   = aws_ec2_transit_gateway.main.id
}
