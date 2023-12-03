output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_public_dns" {
  value = aws_instance.bastion.public_dns
}

output "http_workers_ip" {
  value = merge({
    for idx, w in aws_instance.public_bash_http_worker[*] : "public-http-server-${idx}-private-dns" => w.private_dns
    }, {
    for idx, w in aws_instance.private_bash_http_worker[*] : "private-http-server-${idx}-private-dns" => w.private_dns
  })
}