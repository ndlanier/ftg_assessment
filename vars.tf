variable "app_count" {
    type = number
    default = 1
}
variable "domain" {
    type = string
}
variable "instance_type" {
    type = string
}
variable "tag_domain" {
    type = string
}
variable "volume_type" {
    type = string
}
variable "ebs_volume_size" {}

variable "cidr" {
    default = "172.32.0.0/16"
}

variable "app_name" {
    default = "resumeApp"
}

variable "default_vpc" {
    default = "vpc-856d05ee"
}