resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = replace(aws_lambda_function_url.app.function_url, "/(^https://)|(/$)/", "")
    origin_id   = "default"

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled             = true # required
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "default"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  # required
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # required
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
