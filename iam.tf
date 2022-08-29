resource "aws_iam_policy" "grupo-polyce-vpn" {
  name = "grupo-polyce-vpn"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [ 
         "arn:aws:s3:::grupotfstate",
         "arn:aws:s3:::grupotfstate/*" 
      ] 
    }
  ]
}
EOF
}

resource "aws_iam_role" "grupo_role_vpn" {
  name = "gropo-role-vpn"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy_attachment" "policy_role_attach" {
    name = "grupoterraform"
    policy_arn = aws_iam_policy.grupo-polyce-vpn.arn
    roles = [aws_iam_role.grupo_role_vpn.name]
}