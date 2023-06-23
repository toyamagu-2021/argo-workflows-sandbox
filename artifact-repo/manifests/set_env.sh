cd ../terraform
S3_BUCKET_NAME=$(terraform output --raw s3_bucket_name)
ACCESS_KEY_ID=$(terraform output --raw access_key_id)
ACCESS_KEY_SECRET=$(terraform output --raw access_key_secret)
cd -
