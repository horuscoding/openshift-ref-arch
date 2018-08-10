resource "aws_security_group" "bastion-sg" {
    name = "bastion-sg"
    description = "Security Group for bastion instance"
    vpc_id = "${var.vpc}"
    ingress {
        from_port   = 8
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol    = -1
        from_port   = 0 
        to_port     = 0 
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "Bastion"
        clusterid = "${var.clusterid}"
    }
}

resource "aws_security_group" "infra-sg" {
    name = "infra-sg"
    description = "Security Group for infrastructure instances"
    vpc_id = "${var.vpc}"
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 9200
        to_port     = 9200
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 9300
        to_port     = 9300
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        security_groups = ["${aws_security_group.bastion-sg.id}"]
    }
    egress {
        protocol    = -1
        from_port   = 0 
        to_port     = 0 
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "Infra"
        clusterid = "${var.clusterid}"
    }
}

resource "aws_security_group" "master-sg" {
    name = "master-sg"
    description = "Security Group for master instances"
    vpc_id = "${var.vpc}"
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 2379
        to_port     = 2380
        protocol    = "tcp"
        self = "true"
    }
    ingress {
        from_port   = 24224
        to_port     = 24224
        protocol    = "tcp"
        self = "true"
    }
    ingress {
        from_port   = 2379
        to_port     = 2380
        protocol    = "tcp"
        security_groups = ["${aws_security_group.node-sg.id}"]
    }
    ingress {
        from_port   = 24224
        to_port     = 24224
        protocol    = "udp"
        self = "true"
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        security_groups = ["${aws_security_group.bastion-sg.id}"]
    }
    egress {
        protocol    = -1
        from_port   = 0 
        to_port     = 0 
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "Master"
        clusterid = "${var.clusterid}"
    }
}

resource "aws_security_group" "node-sg" {
    name = "node-sg"
    description = "Security group for application node instances"
    vpc_id = "${var.vpc}"
    ingress {
        from_port   = 8
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 53
        to_port     = 53
        protocol    = "tcp"
        self = "true"
    }
    ingress {
        from_port   = 2049
        to_port     = 2049
        protocol    = "tcp"
        self = "true"
    }
    ingress {
        from_port   = 8053
        to_port     = 8053
        protocol    = "tcp"
        self = "true"
    }
    ingress {
        from_port   = 10250
        to_port     = 10250
        protocol    = "tcp"
        self = "true"
    }
    ingress {
        from_port   = 53
        to_port     = 53
        protocol    = "udp"
        self = "true"
    }
    ingress {
        from_port   = 4789
        to_port     = 4789
        protocol    = "udp"
        self = "true"
    }
    ingress {
        from_port   = 8053
        to_port     = 8053
        protocol    = "udp"
        self = "true"
    }
    egress {
        protocol    = -1
        from_port   = 0 
        to_port     = 0 
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "Node"
        clusterid = "${var.clusterid}"
    }
}

output "bastion_sg" {
    value = "${aws_security_group.bastion-sg.id}"
}

output "master_sg" {
    value = "${aws_security_group.master-sg.id}"
}

output "infra_sg" {
    value = "${aws_security_group.infra-sg.id}"
}

output "node_sg" {
    value = "${aws_security_group.node-sg.id}"
}