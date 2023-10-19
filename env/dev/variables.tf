variable "public_subnets" {
    description = "Public subnets"
    default = [
        {
        name              = "sub_pub_a_01",
        cidr_block        = "10.0.0.0/28",
        availability_zone = "a"
        }
    ]
}

variable "private_subnets" {
  description = "Private subnets"
  default = [
    {
      name              = "sub_pri_a_01",
      cidr_block        = "10.0.0.128/28",
      availability_zone = "a"
    },
    {
      name              = "sub_pri_c_01",
      cidr_block        = "10.0.0.144/28",
      availability_zone = "c"
    }
    
  ]
}

variable "group_names" {
          default = [
                    "bb_default_group",
                    "cloudfront_full_access_group",
                    "cloudfront_user_access_group",
                    "waf_full_access_group",
                    "waf_user_access_group",
                    "lambda_full_access_group",
                    "lambda_user_access_group",
                    "acm_full_access_group",
                    "acm_user_access_group",
                    "cloudwatch_full_acceess_group",
                    "cloudwatch_user_access_group",
                    "backup_full_access_group",
                    "backup_user_access_group",
                    "route53_full_access_group",
                    "route53_user_access_group",
                    "s3_full_access_group",
                    "s3_user_access_group",
                    "rds_full_access_group",
                    "rds_user_access_group",
                    "sg_full_access_group",
                    "sg_user_access_group",
                    "ec2_full_access_group", 
                    "ec2_user_access_group",
                    "iam_full_access_group",
                    "iam_user_access_group",
                    "vpc_full_access_group",
                    "vpc_user_access_group",
                    "natgateway_full_access_group",
                    "natgateway_user_access_group",
                    "terraform_full_access_group"
                    ]
}

variable "bb_0_group" {  # 다혜님
  default = [
                    "bb_default_group",
                    "cloudfront_full_access_group",
                    "cloudfront_user_access_group",
                    "waf_full_access_group",
                    "waf_user_access_group",
                    "lambda_full_access_group",
                    "lambda_user_access_group",
                    "acm_full_access_group"
                    ]
}
variable "bb_1_group" { # 지우님
  default = [
                    "bb_default_group",
                    "cloudfront_full_access_group",
                    "cloudfront_user_access_group",
                    "waf_full_access_group",
                    "waf_user_access_group",
                    "lambda_full_access_group",
                    "lambda_user_access_group",
                    "acm_full_access_group",
                    "acm_user_access_group",
                    "cloudwatch_full_acceess_group"
                    ]
}


variable "bb_2_group" { # 이안이형
  default = ["bb_default_group", "terraform_full_access_group",
                      "sg_user_access_group",
                    "ec2_full_access_group", 
                    "ec2_user_access_group",
                    "iam_full_access_group",
                    "iam_user_access_group",
                    "vpc_full_access_group",
                    "vpc_user_access_group"]
}

variable "bb_3_group" { # 성진님
  default = ["bb_default_group",
          "cloudwatch_user_access_group",
                    "backup_full_access_group",
                    "backup_user_access_group",
                    "route53_full_access_group",
                    "route53_user_access_group",
                    "s3_full_access_group",
                    "s3_user_access_group",
                    "rds_full_access_group",
                    ]
}

variable "bb_4_group" { # 승재님
  default = ["bb_default_group",
  "cloudwatch_user_access_group",
                    "backup_full_access_group",
                    "backup_user_access_group",
                    "route53_full_access_group",
                    "route53_user_access_group",
                    "s3_full_access_group",
                    "s3_user_access_group",
                    "rds_full_access_group",
                    "rds_user_access_group"
                    ]
}

variable "bb_5_group" {
  default = ["bb_default_group",
  "ec2_user_access_group",
                    "iam_full_access_group",
                    "iam_user_access_group",
                    "vpc_full_access_group",
                    "vpc_user_access_group",
                    "natgateway_full_access_group",
                    "natgateway_user_access_group"]
}


