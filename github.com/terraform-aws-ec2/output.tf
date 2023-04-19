output "instance_id" {
  value = "${aws_instance.vpn_instance.id}"
}

output "private_ip" {
  value = "${aws_instance.vpn_instance.private_ip}"
}
