resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.url_shortener_api.id

  name        = "default"
  auto_deploy = true

  description = "Created by AWS Lambda"

  route_settings {
    route_key              = "POST /url-shortener"
    throttling_rate_limit  = 5
    throttling_burst_limit = 10
  }
}