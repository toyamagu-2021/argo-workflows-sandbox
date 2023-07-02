output "s3_bucket_name" {
  value = aws_s3_bucket.argowf.id
}

output "argo_wf_role_arn" {
  value = module.irsa_argo_wf.iam_role_arn
}
