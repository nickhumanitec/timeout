resource "random_string" "random" {
  length  = 16
  special = false
}

output "aws_secret_access_key" {
  value = ""
}

output "aws_access_key_id" {
  value = ""
}

output "region" {
  value = "ca-central-1"
}

output "bucket" {
  value = "arn:aws:s3:::${lower(random_string.random.result)}"
}

resource "null_resource" "previous" {}
resource "time_sleep" "wait" {
  depends_on      = [null_resource.previous]
  create_duration = "1500s"
}

resource "null_resource" "next" {
  depends_on = [time_sleep.wait]
}
