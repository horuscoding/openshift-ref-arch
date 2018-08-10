output "registry_user" {
    value = "${aws_iam_user.registry-user.arn}"
}

output "registry_access_key" {
    value="${aws_iam_access_key.registry-access-key.id}"
}

output "registry_secret_key" {
    value = "${aws_iam_access_key.registry-access-key.secret}"
}

output "admin_access_key" {
    value="${aws_iam_access_key.admin-access-key.id}"
}

output "admin_secret_key" {
    value = "${aws_iam_access_key.admin-access-key.secret}"
}