provider "aws" {
  default_tags {
    tags = {
      Stack = "tf-l2"
    }
  }
}

variable "stack" {
  type    = string
  default = "tf-l2"
}

data "aws_region" "current" {}

module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name      = "${var.stack}-lists"
  hash_key  = "PK"
  range_key = "SK"

  attributes = [
    {
      name = "PK"
      type = "S"
    },
    {
      name = "SK"
      type = "S"
    }
  ]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.stack}-network"
  cidr = "10.0.0.0/16"

  azs             = ["${data.aws_region.current.name}a"]
  private_subnets = ["10.0.0.0/24"]

  enable_nat_gateway = false
  create_igw         = false
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.vpc.default_security_group_id]

  endpoints = {
    dynamodb = {
      service         = "dynamodb"
      route_table_ids = module.vpc.private_route_table_ids
    }
  }
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.stack}-tick-a-box"
  description   = "Tickabox Function"
  handler       = "main.lambda_handler"
  runtime       = "python3.12"

  create_lambda_function_url = true

  create_package      = false
  s3_existing_package = {
    bucket = "dev309"
    key    = "app.zip"
  }
}