locals {
  name = "${var.project}-${var.environment}"
}

locals{

    az_name= slice(data.aws_availability_zones.available.names, 0, 2)
}

locals{

    public_subnet_nat= aws_subnet.public[0].id
     default_vpc_id= data.aws_vpc.default.id
}


