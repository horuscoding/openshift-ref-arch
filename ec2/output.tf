output "master_ids" {
    value = ["${aws_instance.master.*.id}"]
}

output "infra_ids" {
    value = ["${aws_instance.infra.*.id}"]
}
output "master_private_ips" {
    value = ["${aws_instance.master.*.private_ip}"]
}
output "infra_private_ips" {
    value = ["${aws_instance.infra.*.private_ip}"]
}
output "node_private_ips" {
    value = ["${aws_instance.node.*.private_ip}"]
}
output "master_private_dns" {
    value = ["${aws_instance.master.*.private_dns}"]
}
output "infra_private_dns" {
    value = ["${aws_instance.infra.*.private_dns}"]
}
output "node_private_dns" {
    value = ["${aws_instance.node.*.private_dns}"]
}
output "bastion_public_ip" {
    value = "${aws_eip.bastion-eip.public_ip}"
}