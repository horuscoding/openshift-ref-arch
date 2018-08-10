resource "aws_elb" "pub-master" {
    name = "${var.clusterid}-public-master"
    internal = "false"
    cross_zone_load_balancing = "true"
    connection_draining = "false"
    security_groups = ["${var.master_sg}"]
    subnets = ["${var.public_subnets}"]
    instances = ["${var.master_ids}"]
    listener = {
        instance_port = "443"
        instance_protocol = "TCP"
        lb_port = "443"
        lb_protocol = "TCP"
    }
    health_check = {
        healthy_threshold = "3"
        unhealthy_threshold = "2"
        target = "HTTPS:443/api"
        interval = "5"
        timeout = "2"
    }
    tags {
        Name = "${var.clusterid}-public-master"
        Clusterid = "${var.clusterid}"
    }
}

resource "aws_elb" "priv-master" {
    name = "${var.clusterid}-private-master"
    internal = "true"
    cross_zone_load_balancing = "true"
    connection_draining = "false"
    security_groups = ["${var.master_sg}"]
    subnets = ["${var.private_subnets}"]
    instances = ["${var.master_ids}"]
    listener = {
        instance_port = "443"
        instance_protocol = "TCP"
        lb_port = "443"
        lb_protocol = "TCP"
    }
    health_check = {
        healthy_threshold = "3"
        unhealthy_threshold = "2"
        target = "HTTPS:443/api"
        interval = "5"
        timeout = "2"
    }
    tags {
        Name = "${var.clusterid}-private-master"
        Clusterid = "${var.clusterid}"
    }
}

resource "aws_elb" "pub-infra" {
    name = "${var.clusterid}-public-infra"
    internal = "false"
    cross_zone_load_balancing = "true"
    connection_draining = "false"
    security_groups = ["${var.infra_sg}"]
    subnets = ["${var.public_subnets}"]
    instances = ["${var.infra_ids}"]
    listener = {
        instance_port = "80"
        instance_protocol = "TCP"
        lb_port = "80"
        lb_protocol = "TCP"
    }
    listener = {
        instance_port = "443"
        instance_protocol = "TCP"
        lb_port = "443"
        lb_protocol = "TCP"
    }
    health_check = {
        healthy_threshold = "2"
        unhealthy_threshold = "2"
        target = "TCP:443"
        interval = "5"
        timeout = "2"
    }
    tags {
        Name = "${var.clusterid}-public-infra"
        Clusterid = "${var.clusterid}"
    }
}