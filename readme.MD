# VPC Module

## This module is developed to create VPC

## Inputs
 
* project(required) - name of the project, for VPC is used
* environment(required) - name of the project for which VPC is used
* cidr_block(optional) - default is 10.0.0.0/16, if required can be overridden
* public_subnet_cidrs(optional) - default are ["10.0.1.0/24","10.0.2.0/24"], can be overridden
* private_cidr_blocks(optional)  - default are ["10.0.11.0/24","10.0.12.0/24"], can be overridden 
* database_subnet_cidrs(optional)  - default are ["10.0.21.0/24","10.0.22.0/24"], can be overridden
* public_subnet_tags(optional)
* private_subnet_tags(optional)
* database_subnet_tags(optional)

## Outputs

* vpc_id - Exports the vpc id created by module
* public_subnet_id - throws public subnet id
* private_subnet_id  - throws private subnet id
* database_subnet_id  - throws database subnet id
