output "access_key_id" {
  value = aws_iam_access_key.argowf.id
  sensitive = true
}

output "access_key_secret" {
  value = aws_iam_access_key.argowf.secret
  sensitive = true
}

output "s3_bucket_name" {
  value = aws_s3_bucket.argowf.id
}
