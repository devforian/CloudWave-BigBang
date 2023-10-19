variable "infra_env" {}
variable "vpc_id" {}
variable "availability_zone_prefix" {
    description = "The prefix of the availability zone"
    type        = string
    default     = "ap-northeast-2"    
}

variable "public_subnets" {}

variable "private_subnets" {}