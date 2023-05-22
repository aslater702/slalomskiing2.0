data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid = "1"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      # "arn:aws:s3:::*",
      "arn:aws:s3:::${aws_s3_bucket.slalom_skiing_primary_bucket.id}",
    ]

    principals {
      type = "AWS"

      identifiers = [
        aws_cloudfront_origin_access_identity.s3_origin_identity.iam_arn,
      ]
    }
  }
}

# creating a Cloudfront origin access identity
resource "aws_cloudfront_origin_access_identity" "s3_origin_identity" {
  comment = "cloudfront/s3 origin identity"
}

# S3 bucket for static website hosting in primary us-west-1 region
resource "aws_s3_bucket" "slalom_skiing_primary_bucket" {
  bucket = "slalom_skiing_primary_bucket"

  tags = {
    Name        = "SS us-east-1 bucket"
  }
}

resource "aws_s3_bucket_website_configuration" "slalom_skiing_website" {
  bucket = aws_s3_bucket.slalom_skiing_primary_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Add homepage(index) and error files to S3 bucket
resource "aws_s3_object" "object" {
  bucket       = aws_s3_bucket.slalom_skiing_primary_bucket.bucket
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/index.html")
}

resource "aws_s3_object" "errorobject" {
  bucket       = aws_s3_bucket.slalom_skiing_primary_bucket.bucket
  key          = "error.html"
  source       = "${path.module}/error.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/error.html")
}