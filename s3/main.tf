resource "aws_s3_bucket" "registry-bucket" {
    bucket = "${var.clusterid}.${var.dns_domain}-registry-storage"
     policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:*"
            ],
            "Principal": {
                "AWS": "${var.registry_user}"
            },
            "Resource": "arn:aws:s3:::${var.clusterid}.${var.dns_domain}-registry-storage",
            "Effect": "Allow",
            "Sid": "1"
        }
    ]
}
EOF
    tags {
        Clusterid = "${var.clusterid}"
    }
}