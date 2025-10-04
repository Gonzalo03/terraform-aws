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

data "aws_iam_policy_document" "lambda_execution" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role" "example" {
  name               = "lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "lambda_execution" {
  role   = aws_iam_role.example.id
  policy = data.aws_iam_policy_document.lambda_execution.json
}

data "archive_file" "example" {
  type        = "zip"
  source_dir = var.code_language == "ts" ? "${path.module}/app/dist" : "${path.module}/app/src"
  output_path = "${path.module}/.terraform/tmp/example.zip"
}

resource "aws_lambda_function" "example" {
  filename         = data.archive_file.example.output_path
  function_name    = "example_lambda_function"
  role             = aws_iam_role.example.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.example.output_base64sha256

  runtime = "nodejs20.x"

  environment {
    variables = var.environment_vars != null ? var.environment_vars : {}
  }

  tags = var.tags != null ? var.tags : {}
}