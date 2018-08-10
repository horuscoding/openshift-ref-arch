output "pub_subnet_1_id" {
    value = "${aws_subnet.public1.id}"
}
output "pub_subnet_2_id" {
    value = "${aws_subnet.public2.id}"
}
output "pub_subnet_3_id" {
    value = "${aws_subnet.public3.id}"
}

output "public_subnets" {
    value = ["${aws_subnet.public1.id}", "${aws_subnet.public2.id}", "${aws_subnet.public3.id}"]
}