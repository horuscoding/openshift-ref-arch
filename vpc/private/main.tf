data "aws_availability_zones" "available-azs" {}

resource "aws_subnet" "private1" {
    vpc_id = "${var.vpc}"
    availability_zone = "${data.aws_availability_zones.available-azs.names[0]}"
    cidr_block = "${var.private_cidr_subnets[0]}"

    tags {
        Name = "openshift-private-subnet-1"
    }
}

resource "aws_subnet" "private2" {
    vpc_id = "${var.vpc}"
    availability_zone = "${data.aws_availability_zones.available-azs.names[1]}"
    cidr_block = "${var.private_cidr_subnets[1]}"

    tags {
        Name = "openshift-private-subnet-2"
    }
}

resource "aws_subnet" "private3" {
    vpc_id = "${var.vpc}"
    availability_zone = "${data.aws_availability_zones.available-azs.names[2]}"
    cidr_block = "${var.private_cidr_subnets[2]}"

    tags {
        Name = "openshift-private-subnet-3"
    }
}

resource "aws_route_table" "opc-nat-rt-1" {
  vpc_id = "${var.vpc}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.nat_gw_ids[0]}"
  }

  tags {
    Name = "${data.aws_availability_zones.available-azs.names[0]}"
  }
}

resource "aws_route_table" "opc-nat-rt-2" {
  vpc_id = "${var.vpc}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.nat_gw_ids[1]}"
  }

  tags {
    Name = "${data.aws_availability_zones.available-azs.names[1]}"
  }
}

resource "aws_route_table" "opc-nat-rt-3" {
  vpc_id = "${var.vpc}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.nat_gw_ids[2]}"
  }

  tags {
    Name = "${data.aws_availability_zones.available-azs.names[2]}"
  }
}

resource "aws_route_table_association" "priv-sn-1-rt-assoc" {
  subnet_id      = "${aws_subnet.private1.id}"
  route_table_id = "${aws_route_table.opc-nat-rt-1.id}"
}

resource "aws_route_table_association" "priv-sn-2-rt-assoc" {
  subnet_id      = "${aws_subnet.private2.id}"
  route_table_id = "${aws_route_table.opc-nat-rt-2.id}"
}

resource "aws_route_table_association" "priv-sn-3-rt-assoc" {
  subnet_id      = "${aws_subnet.private3.id}"
  route_table_id = "${aws_route_table.opc-nat-rt-3.id}"
}