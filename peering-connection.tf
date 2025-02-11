resource "aws_vpc_peering_connection" "peering_conn" {
    count=var.is_peering_required ? 1 : 0
  
  peer_vpc_id   = aws_vpc.main.id #requester
  vpc_id        = local.default_vpc_id #accepter
auto_accept=true

tags =merge(
    var.common_tags,
    
 {
    Name = "${local.name}-peering-default"
  }

  ) 

}


#configure routes for peering for expense project

#private subnet route table
resource "aws_route" "private_sub_peer_rt" {
  count=var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.private_rt.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_conn[count.index].id
} 

#oublic subnet route table
resource "aws_route" "public_sub_peer_rt" {
  count=var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public_rt.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_conn[count.index].id
} 


#database subnet route table
resource "aws_route" "database_sub_peer_rt" {
  count=var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.database_rt.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_conn[count.index].id
} 


#configure routes for peering for default VPC project

#default vpc main route table.
resource "aws_route" "database_sub_peer_rt_default" {
  count=var.is_peering_required ? 1 : 0
  route_table_id            = local.default_vpc_main_rt
  destination_cidr_block    = aws_vpc.main.cidr_block #expense cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_conn[count.index].id
} 

