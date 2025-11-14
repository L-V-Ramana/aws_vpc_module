resource "aws_vpc_peering_connection""defaulted"{
    count = var.is_peering_required == true ? 1 : 0
    vpc_id = aws_vpc.roboshop_vpc.id
    peer_vpc_id = data.aws_vpc.default.id
    
    accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
  auto_accept = true
  tags = merge(local.tags,var.peering_tags,{
    Name = "${var.project}-${var.environment}"
  })
}

resource "aws_route""default_route"{
    count = var.is_peering_required == true ? 1 : 0
    destination_cidr_block = var.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.defaulted[count.index].id
    route_table_id = data.aws_route_table.default_vpc.id

}

resource "aws_route""public-route"{
    count = var.is_peering_required == true ? 1 : 0
    destination_cidr_block = data.aws_vpc.default.cidr_block
    route_table_id = aws_route_table.public.id
    vpc_peering_connection_id = aws_vpc_peering_connection.defaulted[count.index].id
}
resource "aws_route""private-route"{
    count = var.is_peering_required == true ? 1 : 0
    destination_cidr_block = data.aws_vpc.default.cidr_block
    route_table_id = aws_route_table.private.id
    vpc_peering_connection_id = aws_vpc_peering_connection.defaulted[count.index].id
}
resource "aws_route""database-route"{
    count = var.is_peering_required == true ? 1 : 0
    destination_cidr_block = data.aws_vpc.default.cidr_block
    route_table_id = aws_route_table.database.id
    vpc_peering_connection_id = aws_vpc_peering_connection.defaulted[count.index].id
}