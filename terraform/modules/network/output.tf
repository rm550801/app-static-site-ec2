# NETWORK OUTPUT TO BE REUSED

output "vpc_id" {
    value = "${aws_vpc.vpc.id}"
}

output "vpc_sg_pub_id" {
    value = "${aws_security_group.vpc_sg_pub.id}"
}

output "vpc_sn_pub_az1_id" {
    value = "${aws_subnet.sn_pub_az1.id}"
}