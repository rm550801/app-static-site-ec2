# VPC
resource "aws_vpc" "VPC_IAC_CP02" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = "true"
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "IGW_IAC_CP02" {
    vpc_id = aws_vpc.VPC_IAC_CP02.id
}

# SUBNET
resource "aws_subnet" "SUBNET_IAC_CP02" {
    vpc_id                  = aws_vpc.VPC_IAC_CP02.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone       = "us-east-1a"

}

# ROUTE TABLE
resource "aws_route_table" "ROUTETABLE_IAC_CP02" {
    vpc_id = aws_vpc.VPC_IAC_CP02.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW_IAC_CP02.id
    }
}

# SUBNET ASSOCIATION
resource "aws_route_table_association" "ROUTETABLE_SUBNET_IAC_CO02" {
  subnet_id      = aws_subnet.SUBNET_IAC_CP02.id
  route_table_id = aws_route_table.ROUTETABLE_IAC_CP02.id
}

# SECURITY GROUP
resource "aws_security_group" "SECGROUP_IAC_CP02" {
    name        = "SECGROUP-IAC-CP02"
    vpc_id      = aws_vpc.VPC_IAC_CP02.id
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["10.0.0.0/16"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        description = "TCP/80 from All"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

# EC2 INSTANCE

data "template_file" "user_data" {
    template = "${file("./scripts/user_data.sh")}"
}

resource "aws_instance" "EC2_IAC_CP02" {
    ami                    = "ami-02e136e904f3da870"
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.SUBNET_IAC_CP02.id
    vpc_security_group_ids = [aws_security_group.SECGROUP_IAC_CP02.id]
    user_data              = "${base64encode(data.template_file.user_data.rendered)}"
}