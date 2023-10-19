resource "aws_lambda_function" "bb_lambda" {
  function_name    = "bb-${var.infra_env}-${var.function_name}"
  handler          = var.handler   # 이 부분은 코드와 맞게 조정하세요.
  runtime          = var.runtime   # 원하는 런타임을 선택하세요.
  filename         = "${path.module}/../userdata/${var.package_path}" # 람다 패키지 위치
  # source_code_hash = filebase64sha256("${var.source_code_path}") #
  role             = aws_iam_role.bb_role_lambda_sqs.arn
  vpc_config {
    subnet_ids         = var.subnet_ids         #subnet_id list
    security_group_ids = [aws_security_group.bb_labmda_sg.id] #security_group_ids list
  }
}

resource "aws_iam_policy" "bb_lambda_sqs_policy" {
  name        = "bb-${var.infra_env}-${var.function_name}-${var.iam_policy_name}"
  policy      = jsonencode({
    Version = "2012-10-17",
    "Statement": [
      {
        "Sid": "sqs",
        "Effect": "Allow",
        "Action": [
          "sqs:*"
        ],
        "Resource": "${var.sqs_arn}"
      },
      {
        "Sid": "Statement1",
			  "Effect": "Allow",
			  "Action": [
				  "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
				  "ec2:DeleteNetworkInterface"
			  ],
			  "Resource": ["*"]
      },
      {
      "Effect": "Allow",
      "Action": [
        "rds-db:connect",
        "rds:DescribeDBInstances",
        "rds:Connect"
      ],
      "Resource": ["*"]
      }
	  ]
  })
}

resource "aws_iam_role" "bb_role_lambda_sqs" {
  name         = "bb-${var.infra_env}-${var.function_name}-sqs-role"
  assume_role_policy  = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bb-lambda-attach" {
  role       = aws_iam_role.bb_role_lambda_sqs.name
  policy_arn = aws_iam_policy.bb_lambda_sqs_policy.arn
}

resource "aws_security_group" "bb_labmda_sg" {
    name        = "bb-${var.infra_env}-lambda-${var.function_name}-sg"
    vpc_id      = var.vpc_id

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks = ["0.0.0.0/0"] ## 기존 보안 그룹 참조 
    }
    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks = ["0.0.0.0/0"] ## 기존 보안 그룹 참조 
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "bb_${var.infra_env}_lambda_${var.function_name}_sg"
    }
}