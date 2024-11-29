provider "aws" {
  default_tags {
    tags = {
      Stack = "listsapp"
    }
  }
}

variable "stack" {
  type    = string
  default = "listsapp"
}

data "aws_region" "current" {}