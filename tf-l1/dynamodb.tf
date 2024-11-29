resource "aws_dynamodb_table" "list" {
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK" # partition key
  range_key    = "SK" # sort key
  name         = "${var.stack}-list"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }
}