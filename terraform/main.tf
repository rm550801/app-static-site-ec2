module "network" {
    source               = "./modules/network"
    vpc_cidr             = "10.0.0.0/16"
    vpc_az1              = "${var.vpc_az1}"
    vpc_sn_pub_az1_cidr  = "${var.vpc_sn_pub_az1_cidr}"
}

module "compute" {
    source               = "./modules/compute"
    ec2_lt_name          = "${var.ec2_lt_name}"
    ec2_lt_ami           = "${var.ec2_lt_ami}"
    ec2_lt_instance_type = "${var.ec2_lt_instance_type}"
    vpc_cidr             = "${var.vpc_cidr}"
    vpc_id               = "${module.network.vpc_id}"
    vpc_sn_pub_az1_id    = "${module.network.vpc_sn_pub_az1_id}"
    vpc_sg_pub_id        = "${module.network.vpc_sg_pub_id}"
}