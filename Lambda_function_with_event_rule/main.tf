# create IAM role for Lambda
resource "aws_iam_role" "ec2-with-lambda" {
  name = "ec2-with-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#Create IAM policy which allows access logs in cloudwatch and EC2 
resource "aws_iam_policy" "access-to-ec2" {
  name        = "access-to-ec2"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:Start*",
                "ec2:Stop*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# Attach Role and Policy to each other
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.ec2-with-lambda.name
  policy_arn = aws_iam_policy.access-to-ec2.arn
}



#Create lambda function

#Start EC2 Lambda Function
resource "aws_lambda_function" "start_lambda" {
  filename      = data.archive_file.start.output_path
  function_name = "start_ec2_instances"
  role          = aws_iam_role.ec2-with-lambda.arn
  handler       = "start_instance_code.lambda_handler"
  #source_code_hash = "${base64sha256(file("start_instances.zip"))}"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:

  #source_code_hash = filebase64sha256("start_instances.zip")

  runtime = "python3.8"
}


#Stop EC2 Lambda Function
resource "aws_lambda_function" "stop_lambda" {
  filename      = data.archive_file.stop.output_path
  function_name = "stop_ec2_instances"
  role          = aws_iam_role.ec2-with-lambda.arn
  handler       = "stop_instance_code.lambda_handler"
  #source_code_hash = "${base64sha256(file("start_instances.zip"))}"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:

  #source_code_hash = filebase64sha256("start_instances.zip")

  runtime = "python3.8"
}


# Create Event Rule for start lambda function

resource "aws_cloudwatch_event_rule" "start_event_rule" {
  name        = "start-event-rule"
  description = "ec2 starts at scheduled cron time"
  schedule_expression = "cron(20 18 * * ? *)"
}

resource "aws_cloudwatch_event_target" "start_target" {
  #target_id = "lambda"
  rule      = aws_cloudwatch_event_rule.start_event_rule.name
  arn       = aws_lambda_function.start_lambda.arn
}

resource "aws_lambda_permission" "allow_start_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_event_rule.arn

}


# Create Event Rule for start lambda function

resource "aws_cloudwatch_event_rule" "stop_event_rule" {
  name        = "stop-event-rule"
  description = "ec2 stops at scheduled cron time"
  schedule_expression = "cron(30 18 * * ? *)"
}

resource "aws_cloudwatch_event_target" "stop_target" {
  #target_id = "lambda"
  rule      = aws_cloudwatch_event_rule.stop_event_rule.name
  arn       = aws_lambda_function.stop_lambda.arn
}

resource "aws_lambda_permission" "allow_stop_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_event_rule.arn

}