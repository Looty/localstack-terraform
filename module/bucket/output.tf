output "name" {
  value = aws_s3_bucket.bucket.bucket_domain_name
}

output "region" {
  value = aws_s3_bucket.bucket.region
}

output "force_destroy" {
  value = aws_s3_bucket.bucket.force_destroy
}
