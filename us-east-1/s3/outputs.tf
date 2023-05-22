output "s3_bucket_name" {
  value = aws_s3_bucket.slalom_skiing_primary_bucket.id
}

output "s3_domain_name" {
  value = aws_s3_bucket_website_configuration.slalom_skiing_website.website_domain
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.slalom_skiing_primary_bucket.arn
}
