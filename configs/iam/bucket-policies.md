## IAM Policies for bucket access
### Read/Write access to specific bucket
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::my-bucket"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::my-bucket/*"
        }
    ]
}

```

### Full access to every bucket
```json
{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Effect":"Allow",
            "Action":[
                "admin:*"
            ]
        },
        {
            "Effect":"Allow",
            "Action":[
                "kms:*"
            ]
        },
        {
            "Effect":"Allow",
            "Action":[
                "s3:*"
            ],
            "Resource":[
                "arn:aws:s3:::*"
            ]
        }
    ]
}
```