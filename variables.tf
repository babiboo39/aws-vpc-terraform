variable "environment" {
    default = "development"
}

variable "public_subnets" {
    description = "variables for public subnets"
}

variable "private_subnets" {
    description = "variables for private subnets"
}

variable "vpc" {
    description = "Variables for VPC"
}

variable "dhcp_opts" {
    description = "variables for DHCP Options Set"
}

variable "destination_cidr_block" {
    description = "List of destination cidr block"
}

variable "sts" {
    description = "Variables for Site to Site VPN"
}