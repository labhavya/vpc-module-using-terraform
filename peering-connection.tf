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