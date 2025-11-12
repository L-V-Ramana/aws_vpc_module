locals {
    tags = {
        Project = var.project
        environment = var.environment
        terraform = true 
    }     
    
    availability_zone = slice(data.aws_availability_zones.myregion.names,0,3)
}