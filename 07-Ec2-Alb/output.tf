
output "http_server_ip" {
  value = values(aws_instance.Http_servers).*.id

}

output "elb_dns" {
  value = aws_elb.my_elb

}