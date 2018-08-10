resource "aws_key_pair" "keypair" {
    key_name = "${var.clusterid}.${var.dns_domain}"
    public_key = "${file("~/.ssh/${var.clusterid}.${var.dns_domain}.pub")}"
}

########## Bastion ##########
resource "aws_eip" "bastion-eip" {
    vpc = "true"
    tags {
        Name = "bastion"
    }
}
resource "template_file" "bastion_user_data" {
    template = "${file("./ec2/bootstrap/bastion-user-data.txt")}"
}
resource "aws_instance" "bastion" {
    ami = "${var.rhel_ami_id}"
    instance_type = "${var.ec2_type_bastion}"
    key_name = "${var.clusterid}.${var.dns_domain}"
    vpc_security_group_ids = ["${var.bastion_sg}"]
    subnet_id = "${var.public_subnets[0]}"
    associate_public_ip_address = "true"
    user_data = "${template_file.bastion_user_data.rendered}"
    ebs_block_device = {
        device_name = "/dev/sda1"
        delete_on_termination = "true"
        volume_size = "25"
    }
    provisioner "file" {
        content = <<EOF
Host bastion
  HostName                 ${aws_eip.bastion-eip.public_ip}
  User                     ec2-user
  StrictHostKeyChecking    no
  ProxyCommand             none
  CheckHostIP              no
  ForwardAgent             yes
  ServerAliveInterval      15
  TCPKeepAlive             yes
  ControlMaster            auto
  ControlPath              ~/.ssh/mux-%r@%h:%p
  ControlPersist           15m
  ServerAliveInterval      30
  IdentityFile             ~/.ssh/${var.clusterid}.${var.dns_domain}

Host *.compute-1.amazonaws.com
  ProxyCommand             ssh -w 300 -W %h:%p bastion
  user                     ec2-user
  StrictHostKeyChecking    no
  CheckHostIP              no
  ServerAliveInterval      30
  IdentityFile             ~/.ssh/${var.clusterid}.${var.dns_domain}

Host *.ec2.internal
  ProxyCommand             ssh -w 300 -W %h:%p bastion
  user                     ec2-user
  StrictHostKeyChecking    no
  CheckHostIP              no
  ServerAliveInterval      30
  IdentityFile             ~/.ssh/${var.clusterid}.${var.dns_domain}
  EOF
        destination = "~/.ssh/config-${var.clusterid}.${var.dns_domain}"
        connection {
            type = "ssh"
            user = "ec2-user"
            agent = "false"
            private_key = "${file("~/.ssh/${var.clusterid}.${var.dns_domain}")}"
        }
    }
                
    provisioner "file" {
        source = "./ec2/bootstrap/ec2-base-packages.sh"
        destination = "~/ec2-base-packages.sh"
        connection {
            type = "ssh"
            user = "ec2-user"
            agent = "false"
            private_key = "${file("~/.ssh/${var.clusterid}.${var.dns_domain}")}"
        }
    }

    provisioner "file" {
        source = "./ec2/bootstrap/ec2-base-packages.yml"
        destination = "~/ec2-base-packages.yml"
        connection {
            type = "ssh"
            user = "ec2-user"
            agent = "false"
            private_key = "${file("~/.ssh/${var.clusterid}.${var.dns_domain}")}"
        }
    }

    provisioner "file" {
        source = "./ec2/key/${var.clusterid}.${var.dns_domain}"
        destination = "~/.ssh/id_rsa"
        connection {
            type = "ssh"
            user = "ec2-user"
            agent = "false"
            private_key = "${file("~/.ssh/${var.clusterid}.${var.dns_domain}")}"
        }
    }

    provisioner "remote-exec" {
        inline = [
            "ln -s ~/.ssh/config-${var.clusterid}.${var.dns_domain} ~/.ssh/config",
            "chmod 400 ~/.ssh/config-${var.clusterid}.${var.dns_domain}",
            "chmod 400 ~/.ssh/id_rsa",
            "chmod u+x ~/ec2-base-packages.sh"
        ]
        connection {
            type = "ssh"
            user = "ec2-user"
            agent = "false"
            private_key = "${file("~/.ssh/${var.clusterid}.${var.dns_domain}")}"
        }
    }  

    tags {
        Name = "openshift-bastion"
        Clusterid = "${var.clusterid}"
    }
}

resource "aws_eip_association" "bastion-assoc" {
    instance_id = "${aws_instance.bastion.id}"
    allocation_id = "${aws_eip.bastion-eip.id}"
}

########## Masters ##########
resource "template_file" "master_user_data" {
    template = "${file("./ec2/bootstrap/master-user-data.txt")}"
}

resource "aws_instance" "master" {
    count = 3
    ami = "${var.rhel_ami_id}"
    instance_type = "${var.ec2_type_master}"
    key_name = "${var.clusterid}.${var.dns_domain}"
    vpc_security_group_ids = ["${var.master_sg}"]
    subnet_id = "${element(var.private_subnets, count.index)}"
    associate_public_ip_address = "false"
    user_data = "${template_file.master_user_data.rendered}"
    ebs_block_device = {
        device_name = "/dev/sda1"
        delete_on_termination = "true"
        volume_size = "40"
    }
    ebs_block_device = {
        device_name = "/dev/xvdb"
        delete_on_termination = "true"
        volume_size = "40"
    }
    ebs_block_device = {
        device_name = "/dev/xvdc"
        delete_on_termination = "true"
        volume_size = "40"
    }
    ebs_block_device = {
        device_name = "/dev/xvdd"
        delete_on_termination = "true"
        volume_size = "40"
    }

    tags {
        Name = "openshift-master-${count.index}"
        Clusterid = "${var.clusterid}"
        ami = "${var.rhel_ami_id}"
        "kubernetes.io/cluster/${var.clusterid}" = "${var.clusterid}"
    }
    depends_on = ["aws_eip_association.bastion-assoc"]
}

########## Infrastructure ##########
resource "template_file" "infra_user_data" {
    template = "${file("./ec2/bootstrap/infra-user-data.txt")}"
}

resource "aws_instance" "infra" {
    count = 3
    ami = "${var.rhel_ami_id}"
    instance_type = "${var.ec2_type_infra}"
    key_name = "${var.clusterid}.${var.dns_domain}"
    vpc_security_group_ids = ["${var.infra_sg}"]
    subnet_id = "${element(var.private_subnets, count.index)}"
    associate_public_ip_address = "false"
    user_data = "${template_file.infra_user_data.rendered}"
    ebs_block_device = {
        device_name = "/dev/sda1"
        delete_on_termination = "true"
        volume_size = "40"
    }
    ebs_block_device = {
        device_name = "/dev/xvdb"
        delete_on_termination = "true"
        volume_size = "40"
    }
    ebs_block_device = {
        device_name = "/dev/xvdc"
        delete_on_termination = "true"
        volume_size = "40"
    }
    ebs_block_device = {
        device_name = "/dev/xvdd"
        delete_on_termination = "true"
        volume_size = "40"
    }

    tags {
        Name = "openshift-infra-${count.index}"
        Clusterid = "${var.clusterid}"
        ami = "${var.rhel_ami_id}"
        "kubernetes.io/cluster/${var.clusterid}" = "${var.clusterid}"
    }
    depends_on = ["aws_eip_association.bastion-assoc"]
}

########## Nodes ##########
resource "template_file" "node_user_data" {
    template = "${file("./ec2/bootstrap/node-user-data.txt")}"
}

resource "aws_instance" "node" {
    count = 3
    ami = "${var.rhel_ami_id}"
    instance_type = "${var.ec2_type_node}"
    key_name = "${var.clusterid}.${var.dns_domain}"
    vpc_security_group_ids = ["${var.node_sg}"]
    subnet_id = "${element(var.private_subnets, count.index)}"
    associate_public_ip_address = "false"
    user_data = "${template_file.node_user_data.rendered}"
    ebs_block_device = {
        device_name = "/dev/sda1"
        delete_on_termination = "true"
        volume_size = "40"
    }
    ebs_block_device = {
        device_name = "/dev/xvdb"
        delete_on_termination = "true"
        volume_size = "40"
    }
    ebs_block_device = {
        device_name = "/dev/xvdc"
        delete_on_termination = "true"
        volume_size = "40"
    }
    ebs_block_device = {
        device_name = "/dev/xvdd"
        delete_on_termination = "true"
        volume_size = "40"
    }

    tags {
        Name = "openshift-node-${count.index}"
        Clusterid = "${var.clusterid}"
        ami = "${var.rhel_ami_id}"
        "kubernetes.io/cluster/${var.clusterid}" = "${var.clusterid}"
    }
    depends_on = ["aws_eip_association.bastion-assoc"]
}