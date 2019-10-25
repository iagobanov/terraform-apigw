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


resource "aws_api_gateway_integration" "sqs_integration" {
  count                   = "${var.auto_send_message == false ? 1 : 0}"
  rest_api_id             = "${var.rest_api_id}"
  resource_id             = "${var.resource_id}"
  http_method             = "${var.http_method}"
  integration_http_method = "POST"
  type                    = "${var.type}"
  uri                     = "arn:aws:apigateway:us-east-1:sqs:path/171518999593/:${var.sqs_name}"
  credentials             = "arn:aws:iam::171518999593:role/sqs-execution-role"
  request_parameters      = "${var.request_parameters}"

  depends_on = ["aws_api_gateway_method.method"]

}

resource "aws_api_gateway_integration" "sqs_integration_send_message" {
  count                   = "${var.auto_send_message == true ? 1 : 0}"
  rest_api_id             = "${var.rest_api_id}"
  resource_id             = "${var.resource_id}"
  http_method             = "${var.http_method}"
  integration_http_method = "POST"
  type                    = "${var.type}"
  uri                     = "arn:aws:apigateway:us-east-1:sqs:action/SendMessage"
  credentials             = "arn:aws:iam::171518999593:role/sqs-execution-role"
  request_parameters      = "${var.request_parameters}"

  depends_on = ["aws_api_gateway_method.method"]

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

  depends_on = ["aws_api_gateway_integration.sqs_integration", "aws_api_gateway_integration.sqs_integration_send_message"]
}

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"
  status_code = "${aws_api_gateway_method_response.response_200.status_code}"

  depends_on = ["aws_api_gateway_method_response.response_200"]
}
