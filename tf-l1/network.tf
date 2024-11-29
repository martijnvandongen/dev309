resource "aws_vpc" "network" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "network" {
  vpc_id     = aws_vpc.network.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_vpc_endpoint" "dynamodb_gateway" {
  vpc_id       = aws_vpc.network.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
}

resource "aws_vpc_endpoint_route_table_association" "example" {
  route_table_id  = aws_vpc.network.default_route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb_gateway.id
}