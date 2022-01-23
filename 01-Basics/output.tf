output "My_s3_bucket_versioning" {
        value=aws_s3_bucket.my_bucket.versioning[0].enabled  
}

output "My_s3_bucket_complete_details" {
        value=aws_s3_bucket.my_bucket
}

output "My_iam_user_details" {
        value=aws_iam_user.my_user
}