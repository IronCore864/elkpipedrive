# main vpc
variable "main_vpc_name" {
  type    = string
  default = "elk"
}

variable "main_vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "main_vpc_public_subnets" {
  type = map(any)
  default = {
    "eu-central-1a" = "10.1.1.0/24"
    "eu-central-1b" = "10.1.2.0/24"
    "eu-central-1c" = "10.1.3.0/24"
  }
}

variable "main_vpc_private_subnets" {
  type = map(any)
  default = {
    "eu-central-1a" = "10.1.11.0/24"
    "eu-central-1b" = "10.1.12.0/24"
    "eu-central-1c" = "10.1.13.0/24"
  }
}

# eks
variable "cluster_name" {
  type = string
  default = "test"
}

variable "nodegroup_name" {
  type = string
  default = "test-managed-nodegroup-1"
}
