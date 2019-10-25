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


resource "aws_api_gateway_integration" "http_integration" {
  count                   = "${var.type == "HTTP" ? 1 : 0}"
  rest_api_id             = "${var.rest_api_id}"
  resource_id             = "${var.resource_id}"
  http_method             = "${var.http_method}"
  integration_http_method = "${var.http_method}"
  type                    = "HTTP"
  uri                     = "${var.endpoint}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

  depends_on = ["aws_api_gateway_method.method"]
}

resource "aws_api_gateway_integration" "http_proxy_integration" {
  count                   = "${var.type == "HTTP_PROXY" ? 1 : 0}"
  rest_api_id             = "${var.rest_api_id}"
  resource_id             = "${var.resource_id}"
  http_method             = "${var.http_method}"
  integration_http_method = "${var.http_method}"
  type                    = "HTTP_PROXY"
  uri                     = "${var.endpoint}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

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

  depends_on = ["aws_api_gateway_integration.http_integration", "aws_api_gateway_integration.http_proxy_integration"]
}

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"
  status_code = "${aws_api_gateway_method_response.response_200.status_code}"

  depends_on = ["aws_api_gateway_method_response.response_200"]
}
