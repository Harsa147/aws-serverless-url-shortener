data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_lambda_permission" "api_gateway_post_1" {
  statement_id  = "lambda-626ebaae-51a7-4796-a822-1bcbe28536d3"

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.url_shortener.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.url_shortener_api.id}/*/*/url-shortener"
}

resource "aws_lambda_permission" "api_gateway_get" {
  statement_id  = "ad2d5a2e-8957-595a-b6de-c2fb0256cb79"

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.url_shortener.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.url_shortener_api.id}/*/*/url-shortener/{code}"
}

resource "aws_lambda_permission" "api_gateway_post_2" {
  statement_id = "878ec385-8b4a-501d-adfb-bb2635739498"

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.url_shortener.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.url_shortener_api.id}/*/*/url-shortener"
}