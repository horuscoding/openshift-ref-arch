variable "clusterid" {
    type = "string"
    description = "name for openshift cluster"
}
variable "dns_domain" {
    type = "string"
    description = "domain name to be used for cluster"
}
variable "vpc" {
    type = "string"
    description = "cluster vpc id"
}
variable "pub_master_elb" {
    type = "string"
    description = "public facing elb for masters"
}

variable "priv_master_elb" {
    type = "string"
    description = "internal elb for masters"
}

variable "pub_infra_elb" {
    type = "string"
    description = "public facing elb for infra nodes"
}
