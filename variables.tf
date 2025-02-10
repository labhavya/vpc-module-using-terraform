variable "vpc_cidr_block" {

}

#mandatory
variable "project" {

}

#mandatory

variable "environment" {
  
  
}


variable "common_tags" {
  type        = map
  default     = {

  }
 
}

#mandatory
variable "subnet_private_cidr" {
  type=list

   validation {
    condition   = length(var.subnet_private_cidr) ==2
    error_message = "Please enter 2 valid private subnets'"
  }
}


variable "subnet_public_cidr" {
  type=list

   validation {
    condition   = length(var.subnet_public_cidr) ==2
    error_message = "Please enter 2 valid public subnets'"
  }
}

variable "subnet_database_cidr" {
  type=list

   validation {
    condition   = length(var.subnet_database_cidr) ==2
    error_message = "Please enter 2 valid database subnets'"
  }
}
variable "subnet_tags" {
  
  default     = {}

}


variable igw_tags {
  
  default     = {

  }
 
}

variable "is_peering_required" {
  
}
