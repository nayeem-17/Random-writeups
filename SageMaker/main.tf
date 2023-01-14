provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-24"
  acl    = "private"

}

resource "aws_sagemaker_notebook_instance" "example_notebook" {
  name          = "demo-notebook-for-nlp-hackathon"
  instance_type = "ml.t2.medium"
  role_arn      = aws_iam_role.example_role.arn
}

resource "aws_iam_role" "example_role" {
  name = "example_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sagemaker.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "example_policy" {
  name = "example_policy"
  role = aws_iam_role.example_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.example_bucket.arn}",
        "${aws_s3_bucket.example_bucket.arn}/*"
      ]
    }
  ]
}
EOF
}

variable "filenames" {
  type = map(string)
}

resource "aws_s3_bucket_object" "data_upload" {
  for_each = var.filenames
  bucket   = aws_s3_bucket.example_bucket.id
  key      = "data/${each.key}"
  source   = each.value
}
