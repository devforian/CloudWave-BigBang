resource "aws_security_group" "bb_pub_a_bastion_sg" {
    name            = "bb_${var.infra_env}_pub_a_bastion_sg"
    description     = "Allow web_alb_sg inbound traffic"
    vpc_id          = var.vpc_id

    ingress {
        description = "web from VPC"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "web from VPC"
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "bb_${var.infra_env}_pub_a_bastion_sg"
    }
}

resource "aws_security_group" "bb_web_alb_sg" {
    name        = "bb_${var.infra_env}_web_alb_sg"
    description = "Allow web_alb_sg inbound traffic"
    vpc_id      = var.vpc_id

    ingress {
        description = "web from VPC"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "web from VPC"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "bb_${var.infra_env}_web_alb_sg"
    }
}

resource "aws_security_group" "bb_web_asg_sg" {
    name        = "bb_${var.infra_env}_web_asg_sg"
    description = "Allow web_asg_sg inbound traffic"
    vpc_id      = var.vpc_id

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        security_groups = [aws_security_group.bb_web_alb_sg.id] ## 기존 보안 그룹 참조 
    }
    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [aws_security_group.bb_web_alb_sg.id] ## 기존 보안 그룹 참조 
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "bb_${var.infra_env}_web_asg_sg"
    }
}

resource "aws_security_group" "bb_was_alb_sg" {
    name        = "bb_${var.infra_env}_was_alb_sg"
    description = "Allow was_alb_sg inbound traffic"
    vpc_id      = var.vpc_id

    ingress {
        from_port       = 80   ## 8443
        to_port         = 80   ## 8443
        protocol        = "tcp"
        security_groups = [aws_security_group.bb_web_asg_sg.id] 
    }

    ingress {
    from_port       = -1     
    to_port         = -1     
    protocol        = "icmp" 
    cidr_blocks     = ["0.0.0.0/0"] 
    }


    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "bb_${var.infra_env}_was_alb_sg"
    }
}

resource "aws_security_group" "bb_was_asg_sg" {
    name        = "bb_${var.infra_env}_was_asg_sg"
    description = "Allow was_asg_sg inbound traffic"
    vpc_id      = var.vpc_id

    ingress {
        from_port       = 80   ## 8443
        to_port         = 80   ## 8443
        protocol        = "tcp"
        security_groups = [aws_security_group.bb_was_alb_sg.id] 
    }

    ingress {
    from_port       = -1     
    to_port         = -1     
    protocol        = "icmp" 
    cidr_blocks     = ["0.0.0.0/0"] 
    }


    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "bb_${var.infra_env}_was_asg_sg"
    }
}

resource "aws_security_group" "bb_rds_sg" {
    name        = "bb_${var.infra_env}_rds_sg"
    description = "Allow rds_sg inbound traffic"
    vpc_id      = var.vpc_id

    ingress {
        from_port       = 3306   
        to_port         = 3306
        protocol        = "tcp"
        security_groups = [aws_security_group.bb_was_asg_sg.id] 
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "bb_${var.infra_env}_rds_sg"
    }
}

resource "aws_security_group_rule" "bb_rds_sg_rule" {
    type        = "ingress" // 인바운드 규칙
    from_port   = 3306 // 허용할 포트 범위
    to_port     = 3306
    protocol    = "tcp" // 프로토콜
    cidr_blocks = ["0.0.0.0/0"] // 허용할 IP 범위
    security_group_id = aws_security_group.bb_rds_sg.id // 규칙을 적용할 보안 그룹 ID
}