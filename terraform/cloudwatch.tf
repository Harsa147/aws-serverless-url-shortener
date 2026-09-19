resource "aws_cloudwatch_dashboard" "url_shortener" {
  dashboard_name = "url-shortener-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title = "Lambda Invocations"

          metrics = [
            [
              "AWS/Lambda",
              "Invocations",
              "FunctionName",
              "url-shortener"
            ]
          ]

          period = 300
          stat   = "Sum"
          region = "us-east-1"
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title = "Lambda Errors"

          metrics = [
            [
              "AWS/Lambda",
              "Errors",
              "FunctionName",
              "url-shortener"
            ]
          ]

          period = 300
          stat   = "Sum"
          region = "us-east-1"
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title = "Lambda Duration"

          metrics = [
            [
              "AWS/Lambda",
              "Duration",
              "FunctionName",
              "url-shortener"
            ]
          ]

          period = 300
          stat   = "Average"
          region = "us-east-1"
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          title = "Lambda Throttles"

          metrics = [
            [
              "AWS/Lambda",
              "Throttles",
              "FunctionName",
              "url-shortener"
            ]
          ]

          period = 300
          stat   = "Sum"
          region = "us-east-1"
          view   = "timeSeries"
        }
      }
    ]
  })
}