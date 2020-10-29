provider "aws" {
  region  = "eu-west-2"
  profile = "stage-apptest3"
}

module "vpc0" {
  source                = "./vpc"
  name                  = "vpc0"
  vpc_cidr              = "192.168.0.0/16"
  subnet_out_cidr       = "192.168.0.0/24"
  subnet_in_cidr        = "192.168.1.0/24"
  super_net             = "192.168.0.0/16"
}
