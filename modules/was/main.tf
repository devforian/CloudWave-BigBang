resource "aws_autoscaling_group" "bb_was_asg" {
  name          = "bb_${var.infra_env}_was_ec2"
  launch_template {
    id = var.launch_template
    version = "$Latest"
  }
  min_size             = 2
  max_size             = 20
  desired_capacity     = 2
  health_check_grace_period = 10
  health_check_type         = "EC2"
  force_delete              = true
  vpc_zone_identifier       = var.private_subnet_ids

  tag {
    key = "Name"
    value = "bb_${var.infra_env}_was_asg"
    propagate_at_launch = true
  }
}

resource "aws_cloudwatch_metric_alarm" "bb_was_cpu_alarm_01" {
  alarm_name          = "bb_${var.infra_env}_was_cpu_alarm_01"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "30" # 30초 평가
  statistic           = "Average"
  threshold           = "50"  # CPU 사용률 임계값
  alarm_description  = "Alarm when CPU exceeds 50%"
  alarm_actions      = [aws_autoscaling_policy.bb_step_autoscaling_01.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.bb_was_asg.name
  }
}
resource "aws_autoscaling_policy" "bb_step_autoscaling_01" {
  autoscaling_group_name = aws_autoscaling_group.bb_was_asg.name
  name                   = "bb_${var.infra_env}_was_stepscaling_policy_01"
  policy_type            = "StepScaling"
  adjustment_type        = "PercentChangeInCapacity"
  step_adjustment {
    scaling_adjustment          = 10
    metric_interval_lower_bound = 10.0
    metric_interval_upper_bound = 20.0
  }
  step_adjustment {
    scaling_adjustment          = 30
    metric_interval_lower_bound = 20.0
  }
}
resource "aws_cloudwatch_metric_alarm" "bb_was_cpu_alarm_02" {
  alarm_name          = "bb_${var.infra_env}_was_cpu_alarm_02"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "30" # 30초 평가
  statistic           = "Average"
  threshold           = "50"  # CPU 사용률 임계값
  alarm_description  = "Alarm when CPU exceeds 50%"
  alarm_actions      = [aws_autoscaling_policy.bb_step_autoscaling_02.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.bb_was_asg.name
  }
}
resource "aws_autoscaling_policy" "bb_step_autoscaling_02" {
  autoscaling_group_name = aws_autoscaling_group.bb_was_asg.name
  name                   = "bb_${var.infra_env}_was_stepscaling_policy_02"
  policy_type            = "StepScaling"
  adjustment_type        = "PercentChangeInCapacity"
  step_adjustment {
    scaling_adjustment          = -10
    metric_interval_lower_bound = -20.0
    metric_interval_upper_bound = -10.0
  }
  step_adjustment {
    scaling_adjustment          = -30
    metric_interval_upper_bound = -20.0
  }
}
resource "aws_autoscaling_attachment" "bb_was_att" {
  autoscaling_group_name = aws_autoscaling_group.bb_was_asg.id
  lb_target_group_arn   = var.lb_target_group_arn
}