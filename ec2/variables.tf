variable "clusterid" {
    type = "string"
    description = "name for openshift cluster"
}
variable "dns_domain" {
    type = "string"
    description = "domain name to be used for cluster"
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
variable "bastion_sg" {
    type = "string"
    description = "ID for the bastion security group"
}
variable "master_sg" {
    type = "string"
    description = "ID for the master security group"
}
variable "infra_sg" {
    type = "string"
    description = "ID for the infra security group"
}
variable "node_sg" {
    type = "string"
    description = "ID for the node security group"
}
variable "public_subnets" {
    type = "list"
    description = "list of IDs for public subnets"
}
variable "private_subnets" {
    type = "list"
    description = "list of IDs for private subnets"
}
