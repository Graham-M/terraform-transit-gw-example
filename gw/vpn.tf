resource "aws_customer_gateway" "main" {
  provider   = aws.apptest0
  bgp_asn    = 65000
  ip_address = "18.133.63.179"
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "main" {
  provider            = aws.apptest0
  customer_gateway_id = aws_customer_gateway.main.id
  transit_gateway_id  = aws_ec2_transit_gateway.main.id
  type                = aws_customer_gateway.main.type
}
