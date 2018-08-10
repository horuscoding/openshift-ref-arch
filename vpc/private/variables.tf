variable "private_cidr_subnets" {
    type = "list"
}

variable "vpc" {
  type = "string"
  description = "id for the VPC"
}

variable "nat_gw_ids" {
  type = "list"
  description = "list of nat_gw ids"
}

