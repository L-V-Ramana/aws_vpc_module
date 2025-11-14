output "availability_zone"{
    value = data.aws_availability_zones.myregion
}

output "vpc_id" {
    value = aws_vpc.roboshop_vpc.id
}