resource "aws_iam_group" "Developer" {
  name = "Developer"
  path = "/"
}

resource "aws_iam_group" "Management" {
  name = "Management"
  path = "/"
}