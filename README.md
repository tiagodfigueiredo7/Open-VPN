# Projeto - VPN 
[![NPM](https://img.shields.io/npm/l/react)](https://github.com/tiagodfigueiredo7/awsterralt/blob/main/LICENCE) 

# Sobre o projeto

> Nesse projeto vamos implementar a Open-VPN, usando AWS, Terraform , e Conf Open-VPN Linux ubuntu
O TerraForm será usado para a criação da infra VPC, Ec2, EBS e Security Groups usando data.




#  Infra Cloud

- VPC 
- SUBNET
- IAM
- E2 
- Terraform



##  Projeto 

![Web 1](https://github.com/tiagodfigueiredo7/assets/blob/main/Projeto%202/WhatsApp%20Image%202022-09-04%20at%2017.32.30.jpeg)

 
  



# Tecnologias utilizadas

- Aws 
- GitHub
- Open-VPN
- Terraform
- vscode


##  Executar o projeto



- Pré-requisitos: Conta AWS






##  Terraform


> Abra o terminal e usa o comando a baixo:


```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

```

- Provider 

```

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

```
- backend.tf

```
terraform {
  backend "s3" {
    bucket = "grupotfstate"
    key    = "open-vpn"
    region = "us-east-1"
  }
}


```
- data.tf


```
data "aws_vpc" "vpc_prod" {
  filter {
    name   = "tag:Name"
    values = ["vpc-prod"]
  }
}


data "aws_subnet" "subnet_prod_b" {
  filter {
    name   = "tag:Name"
    values = ["subnet-prod-b"]
  }
}

data "aws_security_group" "grupovpn" {
    name = "grupovpn"
    
}

```
- variables.tf

```
variable "key" {
    default = "gruporpn"                 

}


```
- sg.tf

```
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

```

- output.tf

```
output "ip_address"{
value = aws_instance.Vpn_Grupo.*.public_ip            
}
```


- iam.tf

```
resource "aws_iam_policy" "grupo-polyce-vpn" {
  name = "grupo-polyce-vpn"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [ 
         "arn:aws:s3:::grupotfstate",
         "arn:aws:s3:::grupotfstate/*" 
      ] 
    }
  ]
}
EOF
}

resource "aws_iam_role" "grupo_role_vpn" {
  name = "gropo-role-vpn"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy_attachment" "policy_role_attach" {
    name = "grupoterraform"
    policy_arn = aws_iam_policy.grupo-polyce-vpn.arn
    roles = [aws_iam_role.grupo_role_vpn.name]
}

```


- ec2.tf

```
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
  ami                         = data.aws_ami.ubuntu.id                       
  instance_type               = "t2.micro"                                        
  key_name                    = var.key                                             
  vpc_security_group_ids      = [aws_security_group.openvpn_acess.id]                                                         
  associate_public_ip_address = "true"                                              
  subnet_id                   = data.aws_subnet.subnet_prod_b.id                       

  tags = {
    Name = "Vpn_Grupo"
}
}

resource "aws_eip" "ip-publico" {               
    vpc      = true                             
    instance = aws_instance.Vpn_Grupo.id      
}
```




# Ubuntu


- intalando open_vpn 


```
wget http://git.oi/vpn -O openvpn-sh

```

- chmod open vpn | This installer to ben run with superuser privilegies.

```
chmod +x openvpn-install.sh
sudo ./openvpn-install.sh

```


Public IPv4 address / Hostname 

Which Protocol Should OpenVPN use? 
1) UDP ( recomendado ) 
2) TCP

Protocol List: [1]

What port should OpenVPN listen to? 
Port: [1194]

Select a DNS server for the Clients
[1]


Enter a a name for the first client :
Tiago


Proxima tela vamos analisar se o Open_VPN esta Active ( Running )

```
systemctl status openvpn-server@server.service

```

Inf. credenciais Open-VPN

```
cat /home/ubuntu/tiago.ovpn

```






# Autor

Tiago Domingos Figueiredo 

https://www.linkedin.com/in/tiagodfigueiredo/


![Web 1](https://github.com/tiagodfigueiredo7/assets/blob/main/t.jpg)

