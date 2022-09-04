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