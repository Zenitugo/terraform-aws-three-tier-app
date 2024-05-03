# Query available availability zones
# Declare the data source
data "aws_availability_zones" "az" {
  state = "available"
}


