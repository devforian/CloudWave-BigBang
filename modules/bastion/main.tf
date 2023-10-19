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

resource "aws_instance" "bb_bastion" {
  ami           = data.aws_ami.amzn2.id
  instance_type = var.instance_type
  #key_name = "bb-keypair"
  vpc_security_group_ids = var.vpc_security_group_ids
  availability_zone = var.az
  subnet_id = var.subnet_id
  root_block_device {
      volume_size = var.volume_size
  }
  tags = {
    Name = "bb_${var.infra_env}_pub_a_bastion"
  }
}