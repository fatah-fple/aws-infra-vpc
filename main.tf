#### VPC ####
resource "aws_vpc" "vpc" {
  assign_generated_ipv6_cidr_block = "false"
  cidr_block                       = var.VPC_CIDR_BLOCK
  enable_classiclink               = "false"
  enable_classiclink_dns_support   = "false"
  enable_dns_hostnames             = "true"
  enable_dns_support               = "true"
  instance_tenancy                 = "default"

  tags = {
    Name = var.PROJECT_NAME
    Project = var.PROJECT_NAME
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = concat(aws_vpc.vpc.*.cidr_block, [""])[0]
}

#### Internet Gateway ####
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = format("%s-igw", var.PROJECT_NAME)
    Project = var.PROJECT_NAME
  }
}

##### EIP ####
#resource "aws_eip" "eip_natgw" {
#  vpc = "true"
#  tags = {
#    Name = format("%s-eip-natgw", var.PROJECT_NAME)
#  }
#}
#
##### NAT Gateway ####
#resource "aws_nat_gateway" "nat_gw" {
#  allocation_id = aws_eip.eip_natgw.id
#  subnet_id = aws_subnet.subnet_pub_1a.id
#  tags = {
#    Name = format("%s-natgw", var.PROJECT_NAME)
#    Project = var.PROJECT_NAME
#  }
#}


#### Subnets ####
resource "aws_subnet" "subnet_pub_1a" {
  availability_zone = format("%sa", var.REGION)
  vpc_id = aws_vpc.vpc.id
  cidr_block                      = var.VPC_CIDR_SUBNET_PUB_1A
  map_public_ip_on_launch         = "true"
  assign_ipv6_address_on_creation = "false"

  tags = {
    Name = format("%s-pub-1a", var.PROJECT_NAME)
    Project = var.PROJECT_NAME
  }
}

resource "aws_subnet" "subnet_pub_1b" {
  availability_zone = format("%sb", var.REGION)
  vpc_id = aws_vpc.vpc.id
  cidr_block                      = var.VPC_CIDR_SUBNET_PUB_1B
  map_public_ip_on_launch         = "true"
  assign_ipv6_address_on_creation = "false"

  tags = {
    Name = format("%s-pub-1b", var.PROJECT_NAME)
    Project = var.PROJECT_NAME
  }
}

resource "aws_subnet" "subnet_pub_1c" {
  availability_zone = format("%sc", var.REGION)
  vpc_id = aws_vpc.vpc.id
  cidr_block                      = var.VPC_CIDR_SUBNET_PUB_1C
  map_public_ip_on_launch         = "true"
  assign_ipv6_address_on_creation = "false"

  tags = {
    Name = format("%s-pub-1c", var.PROJECT_NAME)
    Project = var.PROJECT_NAME
  }
}

resource "aws_subnet" "subnet_pvt_1a" {
  availability_zone = format("%sa", var.REGION)
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.VPC_CIDR_SUBNET_PVT_1A
  map_public_ip_on_launch = "false"
  assign_ipv6_address_on_creation = "false"

  tags = {
    Name = format("%s-pvt-1a", var.PROJECT_NAME)
    Project = var.PROJECT_NAME
  }
}

resource "aws_subnet" "subnet_pvt_1b" {
  availability_zone = format("%sb", var.REGION)
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.VPC_CIDR_SUBNET_PVT_1B
  map_public_ip_on_launch = "false"
  assign_ipv6_address_on_creation = "false"

  tags = {
    Name = format("%s-pvt-1b", var.PROJECT_NAME)
    Project = var.PROJECT_NAME
  }
}

resource "aws_subnet" "subnet_pvt_1c" {
  availability_zone = format("%sc", var.REGION)
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.VPC_CIDR_SUBNET_PVT_1C
  map_public_ip_on_launch = "false"
  assign_ipv6_address_on_creation = "false"

  tags = {
    Name = format("%s-pvt-1c", var.PROJECT_NAME)
    Project = var.PROJECT_NAME
  }
}

output "aws_subnet_pub_1a" {
  value = aws_subnet.subnet_pub_1a.id
}

output "aws_subnet_pub_1b" {
  value = aws_subnet.subnet_pub_1b.id
}

output "aws_subnet_pub_1c" {
  value = aws_subnet.subnet_pub_1c.id
}

output "aws_subnet_pvt_1a" {
  value = aws_subnet.subnet_pvt_1a.id
}

output "aws_subnet_pvt_1b" {
  value = aws_subnet.subnet_pvt_1b.id
}

output "aws_subnet_pvt_1c" {
  value = aws_subnet.subnet_pvt_1c.id
}


#### Route Table ####
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = format("%s-rtb-public", var.PROJECT_NAME)
    Project = var.PROJECT_NAME
  }
}

resource "aws_route_table_association" "rta_subnet_pub_1a" {
  route_table_id = aws_route_table.rtb_public.id
  subnet_id = aws_subnet.subnet_pub_1a.id
}

resource "aws_route_table_association" "rta_subnet_pub_1b" {
  route_table_id = aws_route_table.rtb_public.id
  subnet_id = aws_subnet.subnet_pub_1b.id
}

resource "aws_route_table_association" "rta_subnet_pub_1c" {
  route_table_id = aws_route_table.rtb_public.id
  subnet_id = aws_subnet.subnet_pub_1c.id
}

resource "aws_route_table" "rtb_private" {
  vpc_id = aws_vpc.vpc.id
  route = []
  #route {
  #  cidr_block = "0.0.0.0/0"
  #  #nat_gateway_id = aws_nat_gateway.nat_gw.id
  #}

  tags = {
    Name = format("%s-rtb-private", var.PROJECT_NAME)
    Project = var.PROJECT_NAME
  }
}

resource "aws_route_table_association" "rta_subnet_pvt_1a" {
  route_table_id = aws_route_table.rtb_private.id
  subnet_id = aws_subnet.subnet_pvt_1a.id
}

resource "aws_route_table_association" "rta_subnet_pvt_1b" {
  route_table_id = aws_route_table.rtb_private.id
  subnet_id = aws_subnet.subnet_pvt_1b.id
}

resource "aws_route_table_association" "rta_subnet_pvt_1c" {
  route_table_id = aws_route_table.rtb_private.id
  subnet_id = aws_subnet.subnet_pvt_1c.id
}
