output "ip_address"{
value = aws_instance.Vpn_Grupo.*.public_ip            
}