resource "aws_api_gateway_rest_api" "bb_apigw" {
  name = "bb-${var.infra_env}-${var.api_name}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "bb_apigw_resource" {
  parent_id   = aws_api_gateway_rest_api.bb_apigw.root_resource_id
  path_part   = "bborder"
  rest_api_id = aws_api_gateway_rest_api.bb_apigw.id
}

resource "aws_api_gateway_method" "bb_apigw_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.bb_apigw_resource.id
  rest_api_id   = aws_api_gateway_rest_api.bb_apigw.id
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.bb_apigw.id
  resource_id             = aws_api_gateway_resource.bb_apigw_resource.id
  http_method             = aws_api_gateway_method.bb_apigw_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  #uri                     = aws_lambda_function.lambda.invoke_arn
  uri                     = var.lambda_invoke_arn
}