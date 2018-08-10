data "aws_availability_zones" "available-azs" {}
resource "aws_vpc" "ocp-vpc" {
    cidr_block = "172.16.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"

    tags {
        Name = "${var.clusterid}"
    }
}

resource "aws_vpc_dhcp_options" "ocp-vpc-dhcp" {
    #domain_name = "ec2.internal"
    domain_name = "us-east-2.compute.internal"
    domain_name_servers = ["AmazonProvidedDNS"]

    tags {
        Name = "openshift-vpc-dhcp"
    }
}

resource "aws_vpc_dhcp_options_association" "ocp-dhcp-association" {
    vpc_id = "${aws_vpc.ocp-vpc.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.ocp-vpc-dhcp.id}"
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.ocp-vpc.id}"

    tags {
        Name = "openshift-igw"
    }
}

module "private-subnet" {
    source = "./private"
    vpc = "${aws_vpc.ocp-vpc.id}"
    private_cidr_subnets = "${var.private_cidr_subnets}"
    nat_gw_ids = ["${aws_nat_gateway.gw-1.id}", "${aws_nat_gateway.gw-2.id}", "${aws_nat_gateway.gw-3.id}"]
}

module "public-subnet" {
    source = "./public"
    vpc = "${aws_vpc.ocp-vpc.id}"
    igw = "${aws_internet_gateway.igw.id}"
    public_cidr_subnets = "${var.public_cidr_subnets}"
}

module "security-group" {
    source = "./security-group"
    clusterid = "${var.clusterid}"
    vpc = "${aws_vpc.ocp-vpc.id}"
}

resource "aws_eip" "gw-1-eip" {
    vpc = "true"
    tags {
        Name = "${data.aws_availability_zones.available-azs.names[0]}"
    }
}
resource "aws_eip" "gw-2-eip" {
    vpc = "true"
    tags {
        Name = "${data.aws_availability_zones.available-azs.names[1]}"
    }
}
resource "aws_eip" "gw-3-eip" {
    vpc = "true"
    tags {
        Name = "${data.aws_availability_zones.available-azs.names[2]}"
    }
}

resource "aws_nat_gateway" "gw-1" {
    allocation_id = "${aws_eip.gw-1-eip.id}"
    subnet_id = "${module.public-subnet.pub_subnet_1_id}"

    tags {
        Name = "${data.aws_availability_zones.available-azs.names[0]}"
    }
}

resource "aws_nat_gateway" "gw-2" {
    allocation_id = "${aws_eip.gw-2-eip.id}"
    subnet_id = "${module.public-subnet.pub_subnet_2_id}"

    tags {
        Name = "${data.aws_availability_zones.available-azs.names[1]}"
    }
}

resource "aws_nat_gateway" "gw-3" {
    allocation_id = "${aws_eip.gw-3-eip.id}"
    subnet_id = "${module.public-subnet.pub_subnet_1_id}"

    tags {
        Name = "${data.aws_availability_zones.available-azs.names[2]}"
    }
}