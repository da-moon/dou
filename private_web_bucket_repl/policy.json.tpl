{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "InternalReadAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:GetObject",
      "Resource": ["arn:aws:s3:::${bucket_id}/*"],
      "Condition": {
        "IpAddress": {
           "aws:SourceIp": [
                "${cidr1}",
                "${cidr2}",
                "${cidr3}",
                "${cidr4}",
                "${cidr5}",
                "${cidr6}" 
           ]
        }
      }     
    }
  ]
}