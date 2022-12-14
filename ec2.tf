data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}


resource "aws_instance" "Vpn_Grupo" {
  ami                         = data.aws_ami.ubuntu.id                        # apontando pro data de ami, para que seja obrigatorio o uso da ami ubuntu
  instance_type               = "t2.micro"                                          # tipo instancia Ec2. T2 micro
  key_name                    = var.key                                             # variable para a nossa chave de acesso via ssh
  vpc_security_group_ids      = [aws_security_group.openvpn_acess.id]                                                              # abrindo porta ssh no arq. security group
  associate_public_ip_address = "true"                                              # liberando ip publico
  subnet_id                   = data.aws_subnet.subnet_prod_b.id                        # Criando Ec2 direcionando pra subnet correta de cada Vpc usando data.

  tags = {
    Name = "Vpn_Grupo"
}
}

resource "aws_eip" "ip-publico" {               
    vpc      = true                             
    instance = aws_instance.Vpn_Grupo.id      
}
