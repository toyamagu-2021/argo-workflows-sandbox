cd ../terraform
S3_BUCKET_NAME=$(terraform output --raw s3_bucket_name)
ARGO_WF_ROLE_ARN=$(terraform output --raw argo_wf_role_arn)
cd -
