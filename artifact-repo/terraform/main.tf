resource "aws_iam_user" "argowf" {
  name = "${var.prefix}-argo-wf"
}

resource "aws_iam_access_key" "argowf" {
  user = aws_iam_user.argowf.name
}

resource "aws_iam_user_policy" "argo_wf" {
  name   = "${var.prefix}-argo-wf"
  user   = aws_iam_user.argowf.name
  policy = data.aws_iam_policy_document.argowf_s3.json
}

data "aws_iam_policy_document" "argowf_s3" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      #"s3:DeleteObject",
    ]
    resources = ["${aws_s3_bucket.argowf.arn}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = ["${aws_s3_bucket.argowf.arn}"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation"
    ]
    resources = ["arn:aws:s3:::*"]
  }
}

resource "aws_s3_bucket" "argowf" {
  force_destroy = true
}
