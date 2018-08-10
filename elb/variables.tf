variable "clusterid" {
    type = "string"
    description = "name for openshift cluster"
}
variable "dns_domain" {
    type = "string"
    description = "domain name to be used for cluster"
}
variable "master_sg" {
    type = "string"
    description = "security group for master servers"
}
variable "infra_sg" {
    type = "string"
    description = "security group for infra servers"
}
variable "public_subnets" {
    type = "list"
    description = "List of public subnet IDs"
}
variable "private_subnets" {
    type = "list"
    description = "List of private subnet IDs"
}
variable "master_ids" {
    type = "list"
    description = "List of master server instance IDs"
}
variable "infra_ids" {
    type = "list"
    description = "List of infra server instance IDs"
}

