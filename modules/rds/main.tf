######### aurora db subnet group #########
resource "aws_db_subnet_group" "bb_db_subnet_group" {
  name       = "bb_${var.infra_env}_db_subnet_group"
  subnet_ids = var.private_subnet_ids
}


######### Aurora #########
resource "aws_kms_key" "bb_kms" {
  description = "Example KMS Key"
  deletion_window_in_days = 10
}

resource "aws_rds_cluster_instance" "bb_cluster_instances" {
  count              = 3
  identifier         = "bb-${var.infra_env}-aurora-cluster-${count.index}"
  cluster_identifier = aws_rds_cluster.bb_rds_cluster.id
  instance_class     = "db.${var.instance_type}.${var.instance_size}"
  engine             = aws_rds_cluster.bb_rds_cluster.engine
  engine_version     = aws_rds_cluster.bb_rds_cluster.engine_version
  performance_insights_enabled = true
  performance_insights_kms_key_id = aws_kms_key.bb_kms.arn
}

resource "aws_rds_cluster" "bb_rds_cluster" {
  cluster_identifier = "bb-${var.infra_env}-${var.cluster_identifier}"
  db_subnet_group_name = aws_db_subnet_group.bb_db_subnet_group.name
  availability_zones = var.cluster_az_list
  engine             = var.cluster_engine
  engine_version     = var.cluster_engine_ver
  database_name      = var.db_name
  master_username    = var.master_username
  manage_master_user_password = true
  skip_final_snapshot = var.skip_final_snapshot
  storage_encrypted = var.storage_encrypted   #secret manager
  vpc_security_group_ids = var.rds_security_group_ids
}