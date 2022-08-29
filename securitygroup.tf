resource "aws_security_group" "gruporpn-vpn" {
  name        = "gruporpn-vpn"
  description = "liberar acesso ssh"
  vpc_id      = "aws_vpc.vpc-0717a7d19ad87424d.id"

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  ingress {
    description      = "web"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "ssh_access_vpn"
  }
}