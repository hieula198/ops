resource "aws_s3_bucket" "bucket" {
  bucket = lower("${var.project}-ecs-secrets")
}

resource "aws_s3_bucket_public_access_block" "buckets" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}