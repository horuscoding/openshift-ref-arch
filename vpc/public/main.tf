data "aws_availability_zones" "available-azs" {}

resource "aws_subnet" "public1" {
    vpc_id = "${var.vpc}"
    availability_zone = "${data.aws_availability_zones.available-azs.names[0]}"
    cidr_block = "${var.public_cidr_subnets[0]}"

    tags {
        Name = "openshift-public-subnet-1"
    }
}

resource "aws_subnet" "public2" {
    vpc_id = "${var.vpc}"
    availability_zone = "${data.aws_availability_zones.available-azs.names[1]}"
    cidr_block = "${var.public_cidr_subnets[1]}"

    tags {
        Name = "openshift-public-subnet-2"
    }
}

resource "aws_subnet" "public3" {
    vpc_id = "${var.vpc}"
    availability_zone = "${data.aws_availability_zones.available-azs.names[2]}"
    cidr_block = "${var.public_cidr_subnets[2]}"

    tags {
        Name = "openshift-public-subnet-3"
    }
}

resource "aws_route_table" "opc-igw-rt" {
  vpc_id = "${var.vpc}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.igw}"
  }

  tags {
    Name = "routing"
  }
}

resource "aws_route_table_association" "pub-sn-1-rt-assoc" {
  subnet_id      = "${aws_subnet.public1.id}"
  route_table_id = "${aws_route_table.opc-igw-rt.id}"
}

resource "aws_route_table_association" "pub-sn-2-rt-assoc" {
  subnet_id      = "${aws_subnet.public2.id}"
  route_table_id = "${aws_route_table.opc-igw-rt.id}"
}

resource "aws_route_table_association" "pub-sn-3-rt-assoc" {
  subnet_id      = "${aws_subnet.public3.id}"
  route_table_id = "${aws_route_table.opc-igw-rt.id}"
}