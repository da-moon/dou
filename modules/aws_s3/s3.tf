resource "local_file" "spinnaker_secrets_file" {
    content     = replace(yamlencode({sesaws:{"mailfrom":var.mail_from, "seshost":var.seshost, "sesusername":var.sesusername, "sespassword":var.sespassword}}), "\"", "")
    filename    = var.ss_file_location
}

resource "aws_s3_bucket" "aws_s3_bucket_spinnaker" {
    bucket = var.bucket_name 
    acl = "private"
}

resource "time_sleep" "wait_10_seconds" {
  depends_on = [aws_s3_bucket.aws_s3_bucket_spinnaker]

  create_duration = "10s"
}

resource "aws_s3_bucket_object" "object" {
  bucket = var.bucket_name
  key    = var.ss_file_name
  source = var.ss_file_location
  depends_on = [time_sleep.wait_10_seconds]
}