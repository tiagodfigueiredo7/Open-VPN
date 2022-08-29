output "ip_address"{
value = aws_instance.GLPI-Server.*.public_ip            
}