
resource "aws_ssm_parameter" "store-vpcid-ssm" {
  name        = "/${var.project}/${var.environment}/vpc_id"   #/expense/dev/vpc_id
  description = var.ssm_param_desc
  type        = "String"
  value       = aws_vpc.main.id

  tags =merge(
    var.common_tags,
   
 {
    Name = "${local.name}"
  }

)
}

