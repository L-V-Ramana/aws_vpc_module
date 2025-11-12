resource "aws_vpc""roboshop_vpc"{
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true

    tags = merge(local.tags,{
        Name= "${var.project}-${var.environment}"
    })
}

# resource "aws_internet_gateway""roboshop"{
#   vpc_id = aws_vpc.roboshop_vpc.id
#   tags = merge(local.tags,{
#     Name = "${var.project}-${var.environment}"
#   })
# }

resource"aws_subnet""public"{
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.roboshop_vpc.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = local.availability_zone[count.index]
    map_public_ip_on_launch = true 

    tags = merge(local.tags,{
        Name = "${var.project}-${var.environment}public- ${local.availability_zone[count.index]}"
    })
}

resource "aws_subnet""private"{
  count = length(var.private_cidr_blocks)
  vpc_id = aws_vpc.roboshop_vpc.id
  cidr_block = var.private_cidr_blocks[count.index]
  availability_zone = slice(data.aws_availability_zones.myregion.names,0,3)[count.index]

  tags=merge(var.private_subnet_tags,local.tags,
  {
    Name = "${var.project}-${var.environment}-private-${local.availability_zone[count.index]}"
  })

}

resource "aws_subnet""database"{
  count = length(var.database_subnet_cidrs)
  vpc_id = aws_vpc.roboshop_vpc.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.availability_zone[count.index]
  tags =merge(var.database_subnet_tags,local.tags,{
    Name= "${var.project}-${var.environment}-database-${local.availability_zone[count.index]}"
  })
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.roboshop_vpc.id

  tags = merge(var.internet_gateway_tags,local.tags,{
    Name = "${var.project}-${var.environment}"
  })
}

resource "aws_eip" "nat" {
   domain = "vpc"
   tags = merge(var.eip_tags,local.tags,{
    Name = "${var.project}-${var.environment}"
   })
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.nat_gateway_tags,local.tags,{
    Name = "${var.project}-${var.environment}"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.roboshop_vpc.id

    tags = merge(var.public_routetable_tags,local.tags,{
    Name = "${var.project}-${var.environment}-public"
  })
}

resource "aws_route_table""database"{
  vpc_id = aws_vpc.roboshop_vpc.id
  tags = merge(var.databse_routetable_tags,local.tags,{
    Name = "${var.project}-${var.environment}-database"
  })
}
resource "aws_route_table""private"{
  vpc_id = aws_vpc.roboshop_vpc.id
  tags = merge(var.private_routetable_tags,local.tags,{
    Name = "${var.project}-${var.environment}-private"
  })
}

resource"aws_route""public"{
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route""private"{
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.example.id
}

resource "aws_route""batabase"{
  route_table_id = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id= aws_nat_gateway.example.id 
}

resource "aws_route_table_association""public"{
  count = length(var.public_subnet_cidrs)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_rroute_table.public.id
}

resource "aws_route_table_association""private"{
  count = length(var.private_cidr_blocks)
  route_table_id =aws_route_table.private.id
  subnet_id = aws_subnet.private[count.index].id
}

resource "aws_route_table_association""database"{
  count = length(var.database_subnet_cidrs)
  route_table_id = aws_route_table.database.id
  subnet_id = aws_subnet.database[count.index].id
}