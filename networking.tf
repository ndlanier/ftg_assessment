data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_internet_gateway" "aws-igw" {
  vpc_id = var.default_vpc
  tags = {
    Name        = "${var.app_name}-igw"
  }
}

resource "aws_subnet" "private" {
  count = 2
  cidr_block = "${cidrsubnet(var.cidr, 8, 2 + count.index)}"
  availability_zone = "${data.aws_availability_zones.available_zones.names[count.index]}"
  vpc_id = var.default_vpc
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.app_name}-private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id = var.default_vpc
  cidr_block = "${cidrsubnet(var.cidr, 8, count.index)}"
  availability_zone  = "${data.aws_availability_zones.available_zones.names[count.index]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-public-subnet-${count.index + 1}"
  }
}

data "aws_subnet_ids" "public" {
    vpc_id = var.default_vpc

    tags = {
        Name = "${var.app_name}-public-subnet-*"
    }
}