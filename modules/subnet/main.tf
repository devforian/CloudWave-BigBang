locals {
    subnets = {
        "pub" : ["a_01", "c_01"],
        "pri_a" : ["01", "02"],
        "pri_c" : ["01", "02"]
    }
}

######### Public Subnet #########
resource "aws_subnet" "public_subnets" {
    count                   = length(var.public_subnets)
    vpc_id                  = var.vpc_id
    cidr_block              = var.public_subnets[count.index].cidr_block
    availability_zone       = "${var.availability_zone_prefix}${var.public_subnets[count.index].availability_zone}"
    map_public_ip_on_launch = true
    tags = {
        Name = "bb_${var.infra_env}_${var.public_subnets[count.index].name}"
    }
}

######### Private Subnet 01 ~ 04 #########
resource "aws_subnet" "private_subnets" {
    count                   = length(var.private_subnets)
    vpc_id                  = var.vpc_id
    cidr_block              = var.private_subnets[count.index].cidr_block
    availability_zone       = "${var.availability_zone_prefix}${var.private_subnets[count.index].availability_zone}"
    tags = {
        Name = "bb_${var.infra_env}_${var.private_subnets[count.index].name}"
    }
}

######### Internet Gateway #########
resource "aws_internet_gateway" "bb_igw" {
    vpc_id = var.vpc_id

    tags = {
        Name = "bb_${var.infra_env}_igw"
    }
}

######### NAT Gateway && EIP #########
resource "aws_eip" "bb_nat_a" {
    vpc = true
}
resource "aws_eip" "bb_nat_c" {
    vpc = true
}

resource "aws_nat_gateway" "bb_nat_a" {
    allocation_id = aws_eip.bb_nat_a.id
    subnet_id     = aws_subnet.public_subnets[0].id

    tags = {
        Name = "bb_${var.infra_env}_nat_a"
    }
}
resource "aws_nat_gateway" "bb_nat_c" {
    allocation_id = aws_eip.bb_nat_c.id
    subnet_id     = aws_subnet.public_subnets[1].id

    tags = {
        Name = "bb_${var.infra_env}_nat_c"
    }
}

######### route table && association #########
resource "aws_route_table" "bb_rtb_pub" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bb_igw.id
  }

  tags = {
    Name = "bb_${var.infra_env}_rtb_pub"
  }
}
resource "aws_route_table_association" "public" {
  count          = length(local.subnets.pub)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.bb_rtb_pub.id
}

resource "aws_route_table" "private_a" {
  count  = length(local.subnets["pri_a"])
  
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.bb_nat_a.id
  }
  tags = {
    Name = "bb_${var.infra_env}_rtb_pri_a_${local.subnets["pri_a"][count.index]}"
  }
}

resource "aws_route_table_association" "private_a_01" {
  subnet_id      = aws_subnet.private_subnets[0].id
  route_table_id = aws_route_table.private_a[0].id
}

resource "aws_route_table_association" "private_a_02" {
  subnet_id      = aws_subnet.private_subnets[2].id
  route_table_id = aws_route_table.private_a[1].id
}

resource "aws_route_table" "private_c" {
  count  = length(local.subnets["pri_c"])
  
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.bb_nat_c.id
  }
  tags = {
    Name = "bb_${var.infra_env}_rtb_pri_c_${local.subnets["pri_c"][count.index]}"
  }
}
resource "aws_route_table_association" "private_c_01" {
  subnet_id      = aws_subnet.private_subnets[1].id
  route_table_id = aws_route_table.private_c[0].id
}
resource "aws_route_table_association" "private_c_02" {
  subnet_id      = aws_subnet.private_subnets[3].id
  route_table_id = aws_route_table.private_c[1].id
}