output "vpc_id" {
    value = "${aws_vpc.ocp-vpc.id}"
}
output "public_subnets" {
    value = "${module.public-subnet.public_subnets}"
}
output "private_subnets" {
    value = "${module.private-subnet.private_subnets}"
}
output "bastion_sg" {
    value = "${module.security-group.bastion_sg}"
}
output "master_sg" {
    value = "${module.security-group.master_sg}"
}
output "infra_sg" {
    value = "${module.security-group.infra_sg}"
}
output "node_sg" {
    value = "${module.security-group.node_sg}"
}