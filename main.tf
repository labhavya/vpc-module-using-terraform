resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_support= true

  tags =merge(
    var.common_tags,
 {
    Name = local.name
  }

  ) 
}

#create private subnets
 resource "aws_subnet" "main" {
    count=length(var.subnet_private_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_private_cidr[count.index]
  availability_zone= local.az_name[count.index]
 
tags =merge(
    var.common_tags,
    var.subnet_tags,
 {
    Name = "${local.name}-private-${local.az_name[count.index]}"
  }

  ) 
} 

#create public sunets
 resource "aws_subnet" "public" {
    count=length(var.subnet_public_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_public_cidr[count.index]
  availability_zone= local.az_name[count.index]
  map_public_ip_on_launch=true
 
tags =merge(
    var.common_tags,
    var.subnet_tags,
 {
    Name = "${local.name}-public-${local.az_name[count.index]}"
  }

  ) 
} 

#create database subnets
 resource "aws_subnet" "database" {
    count=length(var.subnet_database_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_database_cidr[count.index]
  availability_zone= local.az_name[count.index]
 
tags =merge(
    var.common_tags,
    var.subnet_tags,
 {
    Name = "${local.name}-database-${local.az_name[count.index]}"
  }

  ) 
} 

#create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags =merge(
    var.common_tags,
    var.igw_tags,
 {
    Name = "${local.name}-igw"
  }

  ) 
}

#create EIP for nat gateway

resource "aws_eip" "eip" {
  domain   = "vpc"
}

#create NAT gateway
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

 tags =merge(
    var.common_tags,
    
 {
    Name = "${local.name}-NT"
  }

  ) 
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
} 


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

tags =merge(
    var.common_tags,
   
 {
    Name = "${local.name}-public-RT"
  }

)
}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }

tags =merge(
    var.common_tags,
   
 {
    Name = "${local.name}-private-RT"
  }

)
}


resource "aws_route_table" "database_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }

tags =merge(
    var.common_tags,
   
 {
    Name = "${local.name}-database-RT"
  }

)
}


resource "aws_route_table_association" "public_subs" {
    count=length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id

 
}

resource "aws_route_table_association" "private_subs" {
    count=length(aws_subnet.main)
  subnet_id      = aws_subnet.main[count.index].id
  route_table_id = aws_route_table.private_rt.id
   
}

resource "aws_route_table_association" "database_subs" {
    count=length(aws_subnet.database)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database_rt.id

}