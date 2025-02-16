/* output "az_info" {
  value       = data.aws_availability_zones.available.names
}
 


 output "subnets" {
   value       = aws_subnet.public[0].id
 
 }
 


 output "default_vpc_attributes" {
   value       = data.aws_vpc.default
  
 }
  
 */
  output subnets_private {
    value       = aws_subnet.main[*].id
    
  }

   output subnets_public {
    value       = aws_subnet.public[*].id
    
  }

   output subnets_database {
    value       = aws_subnet.database[*].id
    
  }