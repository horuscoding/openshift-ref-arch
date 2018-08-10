output "pub_master_dns" {
    value = "${aws_elb.pub-master.dns_name}"
}  
output "priv_master_dns" {
    value = "${aws_elb.priv-master.dns_name}"
}  
 output "pub_infra_dns" {
     value = "${aws_elb.pub-infra.dns_name}"
 }   