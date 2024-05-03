# Create vpc for the three tier application
resource "aws_vpc" "main" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy

  enable_dns_hostnames             = true 
  enable_dns_support               = true 

  tags = {
    Name                           = "${var.environment}-${var.name}"
  }
}

##################################################################################################################################
###################################################################################################################################

# Create the internet gateway for the VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-igw"
  }
}

####################################################################################################################################
###################################################################################################################################


# Create subnets for the three tier application which is 2 public subnets and 6 private subnets

# Create public Subnet
resource "aws_subnet" "pub-subnet" {
  count                            = 2
  vpc_id                           = aws_vpc.main.id
  cidr_block                       = cidrsubnet(var.cidr_block, 8, 1)[count.index]
  availability_zone                = data.aws_availability_zones.az[count.index]
  map_public_ip_on_launch          = true 

  tags = {
    Name                           = format("pubsubnet %d", count.index+1)
  }
}

#######################################################################################################################################
#######################################################################################################################################

# Create Private Subnets

# Subnets for the web tier
resource "aws_subnet" "web-pri-subnet" {
  count                            = 2
  vpc_id                           = aws_vpc.main.id
  cidr_block                       = cidrsubnet(var.cidr_block, 8, 3)[count.index]
  availability_zone                = data.aws_availability_zones.az[count.index]
  map_public_ip_on_launch          = true 

  tags = {
    Name                           = format("websubnet %d", count.index+1)
  }
}

# Subnets for the app tier
resource "aws_subnet" "app-pri-subnet" {
  count                            = 2
  vpc_id                           = aws_vpc.main.id
  cidr_block                       = cidrsubnet(var.cidr_block, 8, 5)[count.index]
  availability_zone                = data.aws_availability_zones.az[count.index]
  map_public_ip_on_launch          = true 

  tags = {
    Name                           = format("appsubnet %d", count.index+1)
  }
}


# Subnets for the db tier
resource "aws_subnet" "db-pri-subnet" {
  count                            = 2
  vpc_id                           = aws_vpc.main.id
  cidr_block                       = cidrsubnet(var.cidr_block, 8, 7)[count.index]
  availability_zone                = data.aws_availability_zones.az[count.index]
  map_public_ip_on_launch          = true 

  tags = {
    Name                           = format("dbsubnet %d", count.index+1)
  }
}


###########################################################################################################################
###########################################################################################################################


# Create elastic ips  for web servers

