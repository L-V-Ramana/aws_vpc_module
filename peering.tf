resource "aws_vpc_peering_connection""default"{
    count = var.is_peering_required ? true : false
    peer_vpc_id = data.aws_vpc.default.id # id of, to which vpc we connect
    vpc_id = var.cidr_block #from which vpc peering is estd

    tags = merge (var.peering_tags,local.tags,{
        Name = "${var.project}-${var.environment}"
    })
    auto_accept =  true
}

resource "aws_route""vpc_peering"{
    destination_cidr_block = data.aws_vpc.default.cidr_block
    route_table_id = aws_route_table.public.id
    vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
    
}

resource "aws_route""default_peering"{
    route_table_id = data.aws_route_table.default_vpc.id
    destination_cidr_block = var.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id

}