provider "aws" {
region = "us-west-2"
}

resource "aws_instance" "Homework2" {
ami = "ami-067f5c3d5a99edc80"
instance_type = "t2.large"
associate_public_ip_address = "true"
key_name = "${aws_key_pair.Macbook.key_name}"
#user_data = "${file("userdata.sh")}"
#vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
availability_zone = "us-west-2a"
}

resource "aws_key_pair" "Macbook" {
key_name = "Macbook"
public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_security_group" "allow_ssh" {
name = "allow_ssh"
description = "Allow TLS inbound traffic"
ingress {
description = "Allow ssh"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
description = "Allow HTTPS"
from_port = 443
to_port = 443
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
description = "Allow HTTP"
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}

resource "aws_ebs_volume" "HW_Volume" {
availability_zone = "us-west-2a"
size = 100
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.HW_Volume.id}"
  instance_id = i"${aws_instance.Homework2.id}"
}

resource "aws_route53_record" "www" {
  zone_id = Z05568881JJ7QUZBL3MAJ
  name    = "www.imankulova.com"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.Homework2.public_ip}"]
}