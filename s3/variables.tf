variable "clusterid" {
    type = "string"
    description = "name for openshift cluster"
}

variable "dns_domain" {
    type = "string"
    description = "domain name to be used for cluster"
}

variable "registry_user" {
    type = "string"
    description = "iam user to be used for registry (s3) management"
}
