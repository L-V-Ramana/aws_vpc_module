data "aws_availability_zones""myregion"{
     state  = "available"
}

data "aws_vpc""default"{
     default = true
}

data "aws_route_table" "default_vpc" {
 vpc_id = data.aws_vpc.default.id
}