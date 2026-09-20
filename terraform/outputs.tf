output "frontend_bucket_name" {
  description = "S3 bucket containing the frontend"
  value       = aws_s3_bucket.frontend.bucket
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.frontend.id
}

output "cloudfront_domain_name" {
  description = "CloudFront public domain"
  value       = aws_cloudfront_distribution.frontend.domain_name
}