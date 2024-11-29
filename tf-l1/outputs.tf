output "url" {
  value = aws_lambda_function_url.app.function_url
}

output "cloudfront" {
  value = aws_cloudfront_distribution.distribution.domain_name
}