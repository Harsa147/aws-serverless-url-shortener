resource "aws_apigatewayv2_route" "create_url" {
  api_id = aws_apigatewayv2_api.url_shortener_api.id

  route_key = "POST /url-shortener"

  target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}


resource "aws_apigatewayv2_route" "redirect_url" {
  api_id = aws_apigatewayv2_api.url_shortener_api.id

  route_key = "GET /url-shortener/{code}"

  target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}