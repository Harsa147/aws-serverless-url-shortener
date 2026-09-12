resource "aws_apigatewayv2_api" "url_shortener_api" {
  name          = "url-shortener-api"
  protocol_type = "HTTP"

  description = "Created by AWS Lambda"

  cors_configuration {
    allow_origins = [
      "*",
      "http://127.0.0.1:5500"
    ]

    allow_methods = [
      "GET",
      "POST",
      "OPTIONS"
    ]

    allow_headers = [
      "content-type",
      "accept"
    ]

    max_age = 300
  }
}