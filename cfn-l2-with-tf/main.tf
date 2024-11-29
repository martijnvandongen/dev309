provider "aws" {}

resource "aws_cloudformation_stack" "network" {
  name = "network"

  parameters = {
    VPCCidrBlock = "10.0.0.0/16"
    SubnetCidrBlock = "10.0.0.0/24"
  }

  template_url = "templates/vpc.yaml"
}

resource "aws_cloudformation_stack" "database" {
  name = "database"

  template_url = "templates/dynamodb.yaml"
}

resource "aws_cloudformation_stack" "lambda" {
  name = "lambda"

  parameters = {
    SubnetId = aws_cloudformation_stack.network.outputs.SubnetId
    SecurityGroupId = aws_cloudformation_stack.network.outputs.SecurityGroupId
    RouteTableId = aws_cloudformation_stack.network.outputs.RouteTableId
    ListsTable = aws_cloudformation_stack.database.outputs.ListsTable
    ListsTableArn = aws_cloudformation_stack.database.outputs.ListsTableArn
  }

  template_url = "templates/lambda.yaml"
}
