resource "aws_security_group" "openvpn_acess" {
  name        = "openvpn_acess"
  description = "liberar acesso ssh"
  vpc_id      = data.aws_vpc.vpc_prod.id

}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn_acess.id
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn_acess.id
}

resource "aws_security_group_rule" "vpna" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn_acess.id

}

resource "aws_security_group_rule" "vpnb" {
  type              = "ingress"
  from_port         = 953
  to_port           = 953
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn_acess.id

}

resource "aws_security_group_rule" "vpnc" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn_acess.id

}
