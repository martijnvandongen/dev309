data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "permissions" {
  statement {
    effect  = "Allow"
    actions = ["dynamodb:*"]
    resources = [
      "${aws_dynamodb_table.list.arn}",
      "${aws_dynamodb_table.list.arn}/*"
    ]
  }
}

data "archive_file" "app" {
  type        = "zip"
  source_dir  = "../.build-app/"
  output_path = ".build/lambda_function_payload.zip"
}

resource "aws_iam_role_policy" "app" {
  name   = "lambda"
  role   = aws_iam_role.app.id
  policy = data.aws_iam_policy_document.permissions.json
}

resource "aws_iam_role" "app" {
  name               = "${var.stack}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  ]
}

resource "aws_lambda_function" "app" {
  filename                       = data.archive_file.app.output_path
  function_name                  = "${var.stack}-app"
  role                           = aws_iam_role.app.arn
  source_code_hash               = data.archive_file.app.output_base64sha256
  handler                        = "main.lambda_handler"
  runtime                        = "python3.12"

  vpc_config {
    subnet_ids         = [aws_subnet.network.id]
    security_group_ids = [aws_vpc.network.default_security_group_id]
  }

  environment {
    variables = {
      LISTS_TABLE = aws_dynamodb_table.list.name
    }
  }
}

resource "aws_lambda_function_url" "app" {
  function_name      = aws_lambda_function.app.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}