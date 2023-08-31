# RESOURCE: EC2 LAUNCH TEMPLATE

data "template_file" "user_data" {
    template = "${file("./modules/compute/scripts/user_data.sh")}"
}

#APP-NOTIFIER
resource "aws_instance" "ec2_lt" {
    ami                    = "${var.ec2_lt_ami}"
    subnet_id              = "${var.vpc_sn_pub_az1_id}"
    instance_type          = "${var.ec2_lt_instance_type}"
    key_name               = "${var.ec2_lt_ssh_key_name}"
    user_data              = "${base64encode(data.template_file.user_data.rendered)}"
    vpc_security_group_ids = ["${var.vpc_sg_pub_id}"]
}