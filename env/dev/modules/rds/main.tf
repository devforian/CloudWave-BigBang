resource "aws_kms_key" "bb_kms_key" {
  description = "Postgre MASTER_PASSSWORD KMS Key"
}

resource "aws_db_instance" "bb_dev_rds_instance" {
  allocated_storage    = var.allocated_storage#10
  identifier           = "bb-${var.infra_env}-${var.identifier}"
  db_name              = var.db_name
  engine               = var.engine#"postgres"
  engine_version       = var.engine_version#"14.6"
  instance_class       = var.instance_class #"db.t4g.medium"
  username             = var.username#"foo"
  manage_master_user_password   = true
  master_user_secret_kms_key_id = aws_kms_key.bb_kms_key.key_id
  skip_final_snapshot  = true
  availability_zone = var.availability_zone
  vpc_security_group_ids = [var.vpc_security_group_ids]
  db_subnet_group_name = aws_db_subnet_group.bb_group.name
}

resource "aws_db_subnet_group" "bb_group" {
  name       = "bb_subnet_group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}