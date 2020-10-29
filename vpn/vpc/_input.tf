variable "name" {}
variable "vpc_cidr" {}
variable "subnet_out_cidr" {}
variable "subnet_in_cidr" {}
variable "transit_gw_id" {}
variable "super_net" {}
variable "attach_tgw" {
  default = "True"
}
