resource "template_file" "inventory" {
    template = "${file("aws-openshift-inventory-template.txt")}"

    vars {
        clusterid = "${var.clusterid}"
        dns_domain = "${var.dns_domain}"
        admin_access_key = "${module.iam.admin_access_key}"
        admin_secret_key = "${module.iam.admin_secret_key}"
        s3_access_key = "${module.iam.registry_access_key}"
        s3_secret_key = "${module.iam.registry_secret_key}"
        s3_bucket = "${var.clusterid}.${var.dns_domain}-registry-storage"
        region = "${var.region}"
        master1_dns = "${module.ec2.master_private_dns[0]}"
        master2_dns = "${module.ec2.master_private_dns[1]}"
        master3_dns = "${module.ec2.master_private_dns[2]}"
        node1_dns = "${module.ec2.node_private_dns[0]}"
        node2_dns = "${module.ec2.node_private_dns[1]}"
        node3_dns = "${module.ec2.node_private_dns[2]}"
        infra1_dns = "${module.ec2.infra_private_dns[0]}"
        infra2_dns = "${module.ec2.infra_private_dns[1]}"
        infra3_dns = "${module.ec2.infra_private_dns[2]}"
    }
}

output "inventory" {
    value = "${template_file.inventory.rendered}"
}

output "ssh-config" {
    value = <<EOF
Host bastion
    HostName ${module.ec2.bastion_public_ip}
    User ec2-user
    IdentityFile ~/.ssh/${var.clusterid}.${var.dns_domain}
    ProxyCommand none
Host master1
    HostName ${module.ec2.master_private_ips[0]}
    User ec2-user
    IdentityFile ~/.ssh/${var.clusterid}.${var.dns_domain}
    ProxyCommand ssh bastion -W %h:%p
Host master2
    HostName ${module.ec2.master_private_ips[1]}
    User ec2-user
    IdentityFile ~/.ssh/${var.clusterid}.${var.dns_domain}
    ProxyCommand ssh bastion -W %h:%p
Host master3
    HostName ${module.ec2.master_private_ips[2]}
    User ec2-user
    IdentityFile ~/.ssh/${var.clusterid}.${var.dns_domain}
    ProxyCommand ssh bastion -W %h:%p
Host infra1
    HostName ${module.ec2.infra_private_ips[0]}
    User ec2-user
    IdentityFile ~/.ssh/${var.clusterid}.${var.dns_domain}
    ProxyCommand ssh bastion -W %h:%p
Host infra2
    HostName ${module.ec2.infra_private_ips[1]}
    User ec2-user
    IdentityFile ~/.ssh/${var.clusterid}.${var.dns_domain}
    ProxyCommand ssh bastion -W %h:%p
Host infra3
    HostName ${module.ec2.infra_private_ips[2]}
    User ec2-user
    IdentityFile ~/.ssh/${var.clusterid}.${var.dns_domain}
    ProxyCommand ssh bastion -W %h:%p
Host node1
    HostName ${module.ec2.node_private_ips[0]}
    User ec2-user
    IdentityFile ~/.ssh/${var.clusterid}.${var.dns_domain}
    ProxyCommand ssh bastion -W %h:%p
Host node2
    HostName ${module.ec2.node_private_ips[1]}
    User ec2-user
    IdentityFile ~/.ssh/${var.clusterid}.${var.dns_domain}
    ProxyCommand ssh bastion -W %h:%p
Host node3
    HostName ${module.ec2.node_private_ips[2]}
    User ec2-user
    IdentityFile ~/.ssh/${var.clusterid}.${var.dns_domain}
    ProxyCommand ssh bastion -W %h:%p    
EOF
}