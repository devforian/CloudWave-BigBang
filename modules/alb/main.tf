resource "aws_lb" "bb_web_alb" {
  name               = "bb-${var.infra_env}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.bb_web_alb_sg_id
  subnets            = var.public_subnet_ids
  enable_deletion_protection = false
  tags = {
    Name = "bb_${var.infra_env}_web_alb"
  }
}

resource "aws_lb_target_group" "bb_web_alb_tg" {
  name        = "bb-${var.infra_env}-web-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  
    health_check {
        enabled             = true
        healthy_threshold   = 3
        interval            = 5
        matcher             = "200"
        path                = "/" 
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 2
        unhealthy_threshold = 2
    }
}

resource "aws_lb_listener" "bb_web_alb_ln_01" {
  load_balancer_arn = aws_lb.bb_web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      protocol       = "HTTPS"
      port           = "443"
      status_code    = "HTTP_301" #영구 이동
    }
  }
}


resource "aws_lb_listener" "bb_web_alb_ln_02" {
  load_balancer_arn = aws_lb.bb_web_alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy        = var.ssl_policy
  certificate_arn   = var.bb_acm_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bb_web_alb_tg.arn
  }
}

resource "aws_lb" "bb_was_alb" {
  name               = "bb-${var.infra_env}-was-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.bb_was_alb_sg_id
  #TODO: 나중에 variables에서 리스트로 하기
  subnets            = var.private_subnet_ids
  enable_deletion_protection = false
  tags = {
    Name = "bb_${var.infra_env}_was_alb"
  }
}



resource "aws_lb_target_group" "bb_was_alb_tg" {
  name        = "bb-${var.infra_env}-was-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  
    health_check {
        enabled             = true
        healthy_threshold   = 3
        interval            = 5
        matcher             = "200"
        path                = "/" 
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 2
        unhealthy_threshold = 2
    }
}

resource "aws_lb_listener" "bb_was_alb_ln_01" {
  load_balancer_arn = aws_lb.bb_was_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      protocol       = "HTTPS"
      port           = "443"
      status_code    = "HTTP_301" #영구 이동
    }
  }
}

resource "aws_lb_listener" "bb_was_alb_ln_02" {
  load_balancer_arn = aws_lb.bb_was_alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy        = var.ssl_policy
  certificate_arn   = var.bb_acm_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bb_was_alb_tg.arn
  }
}