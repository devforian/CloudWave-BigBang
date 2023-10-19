#모듈의 변수 쓰는 법 module.모듈의 이름.그 모듈이 쓰는 resource의 output의 이름
provider "aws" {
    region = "ap-northeast-2"
}

provider "aws" {            
    region = "us-east-1"
    alias  = "us"
}

provider "aws" {            
    region = "ap-southeast-1"
    alias  = "sp"
}   

module "bb_vpc" {
    source               = "../../modules/vpc"
    cidr_block           = "10.2.0.0/16"
    instance_tenancy     = "default"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "bb-${local.name}-vpc"
    }
}

module "bb_subnet" {
    source = "../../modules/subnet"
    infra_env = local.name
    vpc_id = module.bb_vpc.vpc_id
    public_subnets = var.public_subnets
    private_subnets = var.private_subnets
}

module "bb_sg" {
    source = "../../modules/sg"
    infra_env = local.name
    vpc_id = module.bb_vpc.vpc_id
}

module "bb_acm" {
    source = "../../modules/acm"
    create_record = true
    infra_env = local.name
    domain_name = "bborder.org"
    web_alb_dns_name = module.bb_alb.bb_web_alb_dns_name
    web_alb_zone_id = module.bb_alb.bb_web_alb_zone_id
    validation_method = "DNS"
    private_zone = false
    ttl = "60"
    record_type = "A"
    sub_domain = "${local.name}"
}

module "bb_acm_us" {
    source = "../../modules/acm"
    create_record = false
    providers = {
        aws  = aws.us
    }
    infra_env = local.name
    domain_name = "bborder.org"
    web_alb_dns_name = module.bb_alb.bb_web_alb_dns_name
    web_alb_zone_id = module.bb_alb.bb_web_alb_zone_id
    validation_method = "DNS"
    private_zone = false
    ttl = "60"
    record_type = "A"
    sub_domain = "${local.name}"
}

module "bb_alb" {
    source = "../../modules/alb"
    infra_env = local.name
    vpc_id = module.bb_vpc.vpc_id
    bb_web_alb_sg_id = [module.bb_sg.bb_web_alb_sg_id]
    public_subnet_ids = module.bb_subnet.public_subnet_ids
    private_subnet_ids = [module.bb_subnet.private_subnet_ids[0], module.bb_subnet.private_subnet_ids[1]]
    bb_acm_cert_arn = module.bb_acm.bb_acm_cert_arn
    bb_was_alb_sg_id = [module.bb_sg.bb_was_alb_sg_id]
    ssl_policy = "ELBSecurityPolicy-2016-08"
}

module "bb_web_tmp" {
    source = "../../modules/tmp"
    infra_env = local.name
    tmp_name = "web"
    security_groups = [module.bb_sg.bb_web_asg_sg_id]
    instance_type = "t3.medium"
    path = "userdata/web_userdata.sh"
}

module "bb_was_tmp" {
    source = "../../modules/tmp"
    infra_env =  local.name
    tmp_name = "was"
    security_groups = [module.bb_sg.bb_was_asg_sg_id]
    instance_type = "m5.xlarge"
    path = "userdata/was_userdata.sh"
}

module "bb_web" {
    source = "../../modules/web"
    infra_env = local.name
    launch_template   = module.bb_web_tmp.bb_tmp_id
    private_subnet_ids      = [module.bb_subnet.private_subnet_ids[0], module.bb_subnet.private_subnet_ids[1]]
    lb_target_group_arn     = module.bb_alb.bb_web_alb_tg_arn
}

module "bb_was" {
    source = "../../modules/was"
    infra_env = local.name
    launch_template    = module.bb_was_tmp.bb_tmp_id
    private_subnet_ids      = [module.bb_subnet.private_subnet_ids[0], module.bb_subnet.private_subnet_ids[1]]
    lb_target_group_arn     = module.bb_alb.bb_was_alb_tg_arn
}

module "bb_bastion" {
    source = "../../modules/bastion"
    infra_env = local.name
    instance_type = "t2.micro"
    az = "ap-northeast-2a"
    volume_size = 30
    vpc_security_group_ids = [module.bb_sg.bb_pub_a_bastion_sg_id]
    subnet_id = module.bb_subnet.public_subnet_ids[0]
}

/*
module "bb_rds" {
    source = "../../modules/rds"
    infra_env = local.name
    private_subnet_ids      = [module.bb_subnet.private_subnet_ids[2], module.bb_subnet.private_subnet_ids[3]] 
    instance_type = "r5"
    instance_size = "large"
    cluster_az_list = ["ap-northeast-2a", "ap-northeast-2c"]
    db_name = "mydb"
    cluster_engine_ver = "14.6"
    cluster_engine = "aurora-postgresql"
    cluster_identifier = "aurora-cluster"
    master_username = "foo"
    skip_final_snapshot = true
    storage_encrypted = true
    rds_security_group_ids = [module.bb_sg.bb_rds_sg_id]
}*/

module "bb_waf" {
    providers = {
        aws  = aws.us
    }
    source = "../../modules/waf"
    infra_env = local.name
}

module "bb_cloudfront" {
    source = "../../modules/cloudfront"
    sub_domain = local.name
    domain_name = "bborder.org"
    cf_domain_name = module.bb_acm.bb_web_alb_record_name
    acm_certificate_arn = module.bb_acm_us.bb_acm_cert_arn
    web_acl_id = module.bb_waf.bb_waf_arn
}

module "bb_sqs_1" {
    source = "../../modules/sqs"
    infra_env = local.name
    sqs_name = "sqs-1"
}

module "bb_sqs_2" {
    source = "../../modules/sqs"
    infra_env = local.name
    sqs_name = "sqs-2"
}

module "bb_sqs_3" {
    source = "../../modules/sqs"
    infra_env = local.name
    sqs_name = "sqs-3"
}

module "bb_sqs_4" {
    source = "../../modules/sqs"
    infra_env = local.name
    sqs_name = "sqs-4"
}

module "bb_apigw" {
    source = "../../modules/apigw"
    infra_env = local.name
    api_name = "apigw"
    lambda_invoke_arn = module.bb_lambda_gw.lambda_function_invoke_arn
    depends_on = [ module.bb_lambda_gw ]
}

module "bb_lambda_gw" {
    source = "../../modules/lambda"
    infra_env = local.name
    function_name = "lambda-gw"
    handler = "lambda_function.lambda_handler"
    runtime = "python3.9"
    package_path = "bb_lambda_01.zip"
    sqs_arn = module.bb_sqs_1.bb_sqs_arn
    subnet_ids = [module.bb_subnet.private_subnet_ids[0], module.bb_subnet.private_subnet_ids[1]]
    iam_policy_name = "bb-lambda-sqs-policy"
    vpc_id = module.bb_vpc.vpc_id
    depends_on = [ module.bb_sqs_1 ]
}

module "bb_lambda_consumer" {
    source = "../../modules/lambda"
    infra_env = local.name
    function_name = "lambda-consumer"
    handler = "lambda_function.lambda_handler"
    runtime = "python3.9"
    package_path = "bb_lambda_01.zip"
    sqs_arn = module.bb_sqs_2.bb_sqs_arn
    subnet_ids = [module.bb_subnet.private_subnet_ids[0], module.bb_subnet.private_subnet_ids[1]]
    iam_policy_name = "bb-lambda-sqs-policy"
    vpc_id = module.bb_vpc.vpc_id
    depends_on = [ module.bb_sqs_2 ]
}

module "bb_lambda_worker" {
    source = "../../modules/lambda"
    infra_env = local.name
    function_name = "lambda-worker"
    handler = "lambda_function.lambda_handler"
    runtime = "python3.9"
    package_path = "bb_lambda_01.zip"
    sqs_arn = module.bb_sqs_3.bb_sqs_arn
    subnet_ids = [module.bb_subnet.private_subnet_ids[0], module.bb_subnet.private_subnet_ids[1]]
    iam_policy_name = "bb-lambda-sqs-policy"
    vpc_id = module.bb_vpc.vpc_id
    depends_on = [ module.bb_sqs_3 ]
}

module "bb_lambda_worker_rds" {
    source = "../../modules/lambda"
    infra_env = local.name
    function_name = "lambda-worker-rds"
    handler = "lambda_function.lambda_handler"
    runtime = "python3.9"
    package_path = "bb_lambda_01.zip"
    sqs_arn = module.bb_sqs_4.bb_sqs_arn
    subnet_ids = [module.bb_subnet.private_subnet_ids[0], module.bb_subnet.private_subnet_ids[1]]
    iam_policy_name = "bb-lambda-sqs-policy"
    vpc_id = module.bb_vpc.vpc_id
    depends_on = [ module.bb_sqs_4 ]
}

module "bb_backup_other_valut" {
    source = "../../modules/backup_other_vault"
    providers = {
        aws = aws.sp
    }
    infra_env = local.name
}

module "bb_backup" {
    source = "../../modules/backup"
    infra_env = local.name
    other_vault_arn = module.bb_backup_other_valut.backup_vault_arn
    depends_on = [module.bb_backup_other_valut]
}

locals {
    name = "${terraform.workspace == "dev" ? "dev" : terraform.workspace == "stg" ? "stg" : "prd" }"
}