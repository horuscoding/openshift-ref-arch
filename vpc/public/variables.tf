variable "public_cidr_subnets" {
    type = "list"
}

variable "vpc" {
  type = "string"
  description = "id for the VPC"
}
variable "igw" {
  type = "string"
  description = "id for internet gateway"
}

