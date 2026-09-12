resource "aws_iam_role" "lambda_role" {
  name = "url-shortener-role-s87ost7w"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy" "dynamodb_access" {
  name = "URLShortenerDynamoDBAccess"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "DynamoDBUrlMappingsAccess"
        Effect = "Allow"

        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]

        Resource = "arn:aws:dynamodb:us-east-1:805046890944:table/url-mappings"
      }
    ]
  })
}