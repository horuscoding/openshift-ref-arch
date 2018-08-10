resource "aws_iam_user" "admin-user" {
    name = "${var.clusterid}.${var.dns_domain}-admin"
}

resource "aws_iam_user" "registry-user" {
    name = "${var.clusterid}.${var.dns_domain}-registry"
}

resource "aws_iam_access_key" "admin-access-key" {
    user = "${aws_iam_user.admin-user.name}"
}

resource "aws_iam_access_key" "registry-access-key" {
    user = "${aws_iam_user.registry-user.name}"
}

resource "aws_iam_user_policy" "admin-compute" {
    name = "admin-compute"
    user = "${aws_iam_user.admin-user.name}"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:CreateVolume",
                "ec2:CreateTags",
                "ec2:DescribeInstances",
                "ec2:AttachVolume",
                "ec2:DetachVolume",
                "ec2:DeleteVolume",
                "ec2:DescribeSubnets",
                "ec2:CreateSecurityGroup",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeRouteTables",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:RevokeSecurityGroupIngress",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:CreateLoadBalancerListeners",
                "elasticloadbalancing:ConfigureHealthCheck",
                "elasticloadbalancing:DeleteLoadBalancerListeners",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:DescribeLoadBalancerAttributes"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "1"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy" "registry-s3" {
    name = "registry-s3"
    user = "${aws_iam_user.registry-user.name}"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::${var.clusterid}.${var.dns_domain}-registry-storage",
                "arn:aws:s3:::${var.clusterid}.${var.dns_domain}-registry-storage/*"
            ],
            "Effect": "Allow",
            "Sid": "1"
        }
    ]
}
EOF
}