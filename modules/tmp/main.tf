resource "aws_launch_template" "bb_tmp" {
  name = "bb-${var.infra_env}-${var.tmp_name}-tmp"
  image_id = data.aws_ami.amzn2.id
  instance_type = var.instance_type
  network_interfaces{
    security_groups     = var.security_groups
  }
  user_data           = filebase64sha256("${path.module}/../${var.path}")
  placement {
    availability_zone = "ap-northeast-2a"
  }
}

data "aws_ami" "amzn2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????.?-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"] # Canonical
}