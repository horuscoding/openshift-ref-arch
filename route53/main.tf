resource "aws_route53_zone" "pub-zone" {
    name = "${var.clusterid}.${var.dns_domain}"
}

resource "aws_route53_zone" "priv-zone" {
    name = "${var.clusterid}.${var.dns_domain}"
    vpc_id = "${var.vpc}"
}

resource "aws_route53_record" "pub-master-record" {
    zone_id = "${aws_route53_zone.pub-zone.zone_id}"
    name = "master.${var.clusterid}.${var.dns_domain}"
    type = "CNAME"
    ttl = "300"
    records = ["${var.pub_master_elb}"]
}

resource "aws_route53_record" "priv-master-record" {
    zone_id = "${aws_route53_zone.priv-zone.zone_id}"
    name = "master.${var.clusterid}.${var.dns_domain}"
    type = "CNAME"
    ttl = "300"
    records = ["${var.priv_master_elb}"]
}

resource "aws_route53_record" "pub-infra-record" {
    zone_id = "${aws_route53_zone.pub-zone.zone_id}"
    name = "*.apps.${var.clusterid}.${var.dns_domain}"
    type = "CNAME"
    ttl = "300"
    records = ["${var.pub_infra_elb}"]
}

resource "aws_route53_record" "priv-infra-record" {
    zone_id = "${aws_route53_zone.priv-zone.zone_id}"
    name = "*.apps.${var.clusterid}.${var.dns_domain}"
    type = "CNAME"
    ttl = "300"
    records = ["${var.pub_infra_elb}"]
}