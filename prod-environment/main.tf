module "vpc" {
    source         = "../childmodules/vpc"
    name           = var.name
    environment    = var.environment
    cidr_block     = var.cidr_block
    instance_tenancy = var.instance_tenancy
    pubsubnet          = var.pubsubnet 
}