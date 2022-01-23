
output "http_server_ip" {
  value = aws_instance.Http_server.public_ip

}