{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "",
         "Effect": "Allow",
         "Principal": {
            "AWS": ["arn:aws:iam::658620301396:root",
                    "arn:aws:iam::038131160342:root",
                    "arn:aws:iam::398155684978:root",
                    "arn:aws:iam::948881759270:root",
                    "arn:aws:iam::217267089143:root",
                    "arn:aws:iam::501520144152:root",
                    "arn:aws:iam::444710398789:root",
                    "arn:aws:iam::948881759270:root"
                   ]
                    
         },
         "Action": [
            "s3:Get*",
            "s3:List*"
         ],
         "Resource": ["arn:aws:s3:::${bucket_id}/*",
                     "arn:aws:s3:::${bucket_id}"]
      }
   ]
}
