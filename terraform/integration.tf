resource "aws_apigatewayv2_integration" "lambda" {
  api_id = aws_apigatewayv2_api.url_shortener_api.id

  integration_type   = "AWS_PROXY"
  integration_method = "POST"

  integration_uri = aws_lambda_function.url_shortener.invoke_arn

  payload_format_version = "2.0"

  timeout_milliseconds = 30000

  lifecycle {
    ignore_changes = [
      integration_uri
    ]
  }
}