resource "aws_lambda_function" "url_shortener" {
  function_name = "url-shortener"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.14"
  handler = "lambda_function.lambda_handler"

  memory_size = 128
  timeout     = 3

  architectures = ["x86_64"]

  package_type = "Zip"

  filename = "../lambda/lambda.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash
    ]
  }
}