variable "clusterid" {
    type = "string"
    description = "name for openshift cluster"
}

variable "public_cidr_subnets" {
    type = "list"
}

variable "private_cidr_subnets" {
    type = "list"
}
