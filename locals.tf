locals {
  name = "${var.project}-${var.environment}"
}

locals{

    az_name= slice(data.aws_availability_zones.available.names, 0, 2)
}

locals{

    public_subnet_nat= aws_subnet.public[0].id
     default_vpc_id= data.aws_vpc.default.id
     default_vpc_cidr=data.aws_vpc.default.cidr_block 
     
     default_vpc_main_rt=data.aws_vpc.default.main_route_table_id 
}


