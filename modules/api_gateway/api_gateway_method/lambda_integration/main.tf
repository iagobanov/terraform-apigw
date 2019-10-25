resource "aws_api_gateway_method" "method" {
  rest_api_id      = "${var.rest_api_id}"
  resource_id      = "${var.resource_id}"
  http_method      = "${var.http_method}"
  authorization    = "NONE"
  api_key_required = "${var.api_key_required}"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}


resource "aws_api_gateway_integration" "lambda_integration" {
  count                   = "${var.http_method == "POST" ? 1 : 0}"
  rest_api_id             = "${var.rest_api_id}"
  resource_id             = "${var.resource_id}"
  http_method             = "POST"
  integration_http_method = "POST"
  type                    = "${var.type}"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:171518999593:function:${var.lambda_name}/invocations"
  credentials             = "arn:aws:iam::171518999593:role/lambda-execution-role"

  depends_on = ["aws_api_gateway_method.method", "aws_lambda_permission.apigw_lambda"]
}

resource "aws_api_gateway_integration" "lambda_integration_get" {
  count                   = "${var.http_method == "GET" ? 1 : 0}"
  rest_api_id             = "${var.rest_api_id}"
  resource_id             = "${var.resource_id}"
  http_method             = "GET"
  integration_http_method = "GET"
  type                    = "${var.type}"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:171518999593:function:${var.lambda_name}/invocations"
  credentials             = "arn:aws:iam::171518999593:role/lambda-execution-role"

  depends_on = ["aws_api_gateway_method.method", "aws_lambda_permission.apigw_lambda"]
}

resource "aws_api_gateway_integration" "lambda_integration_put" {
  count                   = "${var.http_method == "PUT" ? 1 : 0}"
  rest_api_id             = "${var.rest_api_id}"
  resource_id             = "${var.resource_id}"
  http_method             = "PUT"
  integration_http_method = "PUT"
  type                    = "${var.type}"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:171518999593:function:${var.lambda_name}/invocations"
  credentials             = "arn:aws:iam::171518999593:role/lambda-execution-role"

  depends_on = ["aws_api_gateway_method.method", "aws_lambda_permission.apigw_lambda"]
}

resource "aws_lambda_permission" "apigw_lambda" {
  count         = "${var.add_permission == true ? 1 : 0}"
  statement_id  = "AllowExecutionFromAPIGateway${var.lambda_name}"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-1:171518999593:${var.rest_api_id}/*"
}


###### METHOD RESPONSE ######
resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = ["aws_api_gateway_integration.lambda_integration", "aws_api_gateway_integration.lambda_integration_get","aws_api_gateway_integration.lambda_integration_put"]
}


# resource "aws_api_gateway_integration_response" "integration_response" {
#   rest_api_id = "${var.rest_api_id}"
#   resource_id = "${var.resource_id}"
#   http_method = "${var.http_method}"
#   status_code = "${aws_api_gateway_method_response.response_200.status_code}"

#   depends_on = ["aws_api_gateway_method_response.response_200"]
# }
