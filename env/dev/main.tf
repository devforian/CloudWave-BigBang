provider "aws" {
    region = "ap-northeast-2"
}

module "bb_vpc" {
    source                  = "./modules/vpc"
    cidr_block              = "10.0.0.0/24"
    instance_tenancy        = "default"
    enable_dns_support      = true
    enable_dns_hostnames    = true
    tags = {
        Name                = "bb-${local.name}-vpc"
    }
}

### PUBLIC A, PRIVATE A
module "bb_subnet" {
    source          = "./modules/subnet"
    infra_env       = local.name
    vpc_id          = module.bb_vpc.vpc_id
    public_subnets  = var.public_subnets
    private_subnets = var.private_subnets
}

module "bb_sg" {
    source          = "./modules/sg"
    infra_env       = local.name
    vpc_id          = module.bb_vpc.vpc_id
}

module "bb_bastion" {
    source                  = "./modules/bastion"
    infra_env               = local.name
    instance_type           = "t2.micro"
    az                      = "ap-northeast-2a"
    volume_size             = 30
    vpc_security_group_ids  = [module.bb_sg.bastion_sg_id]
    subnet_id               = module.bb_subnet.public_subnets_ids[0]
}

module "bb_web_was" {
    source                  = "./modules/web_was"
    infra_env               = local.name
    instance_type           = "t3.medium"
    az                      = "ap-northeast-2a"
    volume_size             = 30
    vpc_security_group_ids  = [module.bb_sg.web_was_sg_id]
    subnet_id               = module.bb_subnet.public_subnets_ids[0]
}

module "bb_rds" {
    source                  = "./modules/rds"
    infra_env               = local.name
    identifier              = "postgre"
    allocated_storage       = 10
    db_name                 = "devpostgresql" #Only Alphabet
    engine                  = "postgres"
    engine_version          = "14.6"
    instance_class          = "db.t4g.medium"
    username                = "foo"
    vpc_security_group_ids  = module.bb_sg.rds_sg_id
    availability_zone       = "ap-northeast-2a"
    subnet_ids              = module.bb_subnet.private_subnets_ids
}

module "bb_iam_policy" {
    source                  = "./modules/iam/policy"
    infra_policy_files      = local.json_list
}

module "bb_iam_group" {
    source        = "./modules/iam/group"
    group_names   = var.group_names
    depends_on    = [ module.bb_iam_policy ]
}

module "bb_attachment" {
    source        = "./modules/iam/attachment"
    group_names   = var.group_names
    policy_arns   = module.bb_iam_policy.policy_arns
    depends_on    = [ module.bb_iam_group ]
}

module "bb_iam_user" {
    source        = "./modules/iam/user"
    user_names    = ["bb_0", "bb_1", "bb_2", "bb_3", "bb_4", "bb_5"]
    depends_on    = [ module.bb_attachment ]
}


module "bb_user_group_attachment" {
    source        = "./modules/iam/user_group_attachment"
    user_0        = "bb_0"
    user_1        = "bb_1"
    user_2        = "bb_2"
    user_3        = "bb_3"
    user_4        = "bb_4"
    user_5        = "bb_5"
    group_0       = var.bb_0_group
    group_1       = var.bb_1_group
    group_2       = var.bb_2_group
    group_3       = var.bb_3_group
    group_4       = var.bb_4_group
    group_5       = var.bb_5_group
    depends_on    = [ module.bb_iam_user ]
}

locals {
    json_list = [
    "policy_json/bb_default_group.json",
    "policy_json/cloudfront_full_access_group.json",
    "policy_json/cloudfront_user_access_group.json",
    "policy_json/waf_full_access_group.json",
    "policy_json/waf_user_access_group.json",
    "policy_json/lambda_full_access_group.json",
    "policy_json/lambda_user_access_group.json",
    "policy_json/acm_full_access_group.json",
    "policy_json/acm_user_access_group.json",
    "policy_json/cloudwatch_full_access_group.json",
    "policy_json/cloudwatch_user_access_group.json",
    "policy_json/backup_full_access_group.json",
    "policy_json/backup_user_access_group.json",
    "policy_json/route53_full_access_group.json",
    "policy_json/route53_user_access_group.json",
    "policy_json/s3_full_access_group.json",
    "policy_json/s3_user_access_group.json",
    "policy_json/rds_full_access_group.json",
    "policy_json/rds_user_access_group.json",
    "policy_json/sg_full_access_group.json",
    "policy_json/sg_user_access_group.json",
    "policy_json/ec2_full_access_group.json",
    "policy_json/ec2_user_access_group.json",
    "policy_json/iam_full_access_group.json",
    "policy_json/iam_user_access_group.json",
    "policy_json/vpc_full_access_group.json",
    "policy_json/vpc_user_access_group.json",
    "policy_json/natgateway_full_access_group.json",
    "policy_json/natgateway_user_access_group.json",
    "policy_json/terraform_full_access_group.json"
  ]
}

locals {
    name = "${terraform.workspace == "dev" ? "dev" : terraform.workspace == "stg" ? "stg" : "prd" }"
}