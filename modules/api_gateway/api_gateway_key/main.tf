resource "aws_api_gateway_usage_plan" "usage_plan" {
  name = "${var.api_key_name}-usage-plan"

  api_stages {
    api_id = "${var.api_id}"
    stage  = "${var.stage_name}"
  }
}

resource "aws_api_gateway_api_key" "default" {
  name = "${var.api_key_name}"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = "${aws_api_gateway_api_key.default.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.usage_plan.id}"
}