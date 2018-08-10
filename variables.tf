variable "clusterid" {
    type = "string"
    description = "name for openshift cluster"
}
variable "dns_domain" {
    type = "string"
    description = "domain name to be used for cluster"
}
variable "region" {
    type = "string"
    description = "region to deploy infrastructure to (ex: us-east-1)"
}
variable "profile" {
    type = "string"
    description = "the AWS profile to use for access. Should correspond to a profile in your ~/.aws/credentials file"
}

variable "public_cidr_subnets" {
    type = "list"
    description = "cidr blocks for public subnets"
}

variable "private_cidr_subnets" {
    type = "list"
    description = "cidr blocks for private subnets"
}

variable "rhel_ami_id" {
    type = "string"
    description = "ID of the rhel ami to use for openshift deployment"
}
variable "ec2_type_bastion" {
    type = "string"
    description = "instance type for bastion server"
}
variable "ec2_type_master" {
    type = "string"
    description = "instance type for master servers"
}
variable "ec2_type_infra" {
    type = "string"
    description = "instance type for infrastructure servers"
}
variable "ec2_type_node" {
    type = "string"
    description = "instance type for node servers"
}