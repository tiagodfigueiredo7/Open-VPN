data "aws_ami" "ubuntu" {
  most_recent = true
  # ubuntu ami account ID
owners = ["099720109477"]
}


resource "aws_instance" "Vpn_Grupo" {
  ami                         = data.aws_ami.ubuntu.id                        # apontando pro data de ami, para que seja obrigatorio o uso da ami ubuntu
  instance_type               = "t2.micro"                                          # tipo instancia Ec2. T2 micro
  key_name                    = var.key                                             # variable para a nossa chave de acesso via ssh
  vpc_security_group_ids      = [data.aws_security_group.grupovpn.id]                                                              # abrindo porta ssh no arq. security group
  associate_public_ip_address = "true"                                              # liberando ip publico
  subnet_id                   = data.aws_subnet.gruporpnvpn.id                        # Criando Ec2 direcionando pra subnet correta de cada Vpc usando data.

  tags = {
    Name = "GLIP-Server-Terraform"
}
}

resource "aws_eip" "ip-publico" {               
    vpc      = true                             
    instance = aws_instance.Vpn_Grupo.id      
}
