provider "aws" {
  region     = "${var.region}"
  profile = "${var.profile}"
}

#############################################################
##########################  VPC  ############################
#############################################################
module "vpc" {
    source = "./vpc"
    clusterid = "${var.clusterid}"
    public_cidr_subnets = "${var.public_cidr_subnets}"
    private_cidr_subnets = "${var.private_cidr_subnets}"
}

#############################################################
########################  IAM Users  ########################
#############################################################
module "iam" {
    source = "./iam"
    clusterid = "${var.clusterid}"
    dns_domain = "${var.dns_domain}"
}

#############################################################
#######################  S3 Buckets  ########################
#############################################################
module "s3" {
    source = "./s3"
    clusterid = "${var.clusterid}"
    dns_domain = "${var.dns_domain}"
    registry_user  = "${module.iam.registry_user}"
}

#############################################################
#########################  EC2  #############################
#############################################################
module "ec2" {
    source = "./ec2"
    clusterid = "${var.clusterid}"
    dns_domain = "${var.dns_domain}"
    rhel_ami_id = "${var.rhel_ami_id}"
    ec2_type_bastion = "${var.ec2_type_bastion}"
    ec2_type_master = "${var.ec2_type_master}"
    ec2_type_infra = "${var.ec2_type_infra}"
    ec2_type_node = "${var.ec2_type_node}"
    bastion_sg = "${module.vpc.bastion_sg}"
    master_sg = "${module.vpc.master_sg}"
    infra_sg = "${module.vpc.infra_sg}"
    node_sg = "${module.vpc.node_sg}"
    public_subnets = "${module.vpc.public_subnets}"
    private_subnets = "${module.vpc.private_subnets}"
}

#############################################################
########################  ELBs  #############################
#############################################################
module "elb" {
    source = "./elb"
    clusterid = "${var.clusterid}"
    dns_domain = "${var.dns_domain}"
    master_sg = "${module.vpc.master_sg}"
    infra_sg = "${module.vpc.infra_sg}"
    public_subnets = "${module.vpc.public_subnets}"
    private_subnets = "${module.vpc.private_subnets}"
    master_ids = "${module.ec2.master_ids}"
    infra_ids = "${module.ec2.infra_ids}"
}

#############################################################
#######################  Route53  ###########################
#############################################################
module "route53" {
    source = "./route53"
    clusterid = "${var.clusterid}"
    dns_domain = "${var.dns_domain}"
    vpc = "${module.vpc.vpc_id}"
    pub_master_elb = "${module.elb.pub_master_dns}"
    priv_master_elb = "${module.elb.priv_master_dns}"
    pub_infra_elb = "${module.elb.pub_infra_dns}"
}