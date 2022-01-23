output "http_server_sg_output" {
  value = aws_security_group.http_sg

}
output "http_server_ip" {
  value = aws_instance.Http_server.public_ip

}