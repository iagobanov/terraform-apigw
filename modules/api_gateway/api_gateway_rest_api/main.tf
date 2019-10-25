resource "aws_api_gateway_rest_api" "default_api" {
  name = "${var.api_name}"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_domain_name" "api_domain" {
  certificate_arn = "${data.aws_acm_certificate.aws_pi.arn}"
  domain_name     = "${var.api_domain_name}.soupi.com.br"
}

resource "aws_route53_record" "api_record" {
  name    = "${aws_api_gateway_domain_name.api_domain.domain_name}"
  type    = "A"
  zone_id = "${var.zone_id}"

  alias {
    evaluate_target_health = true
    name       = "${aws_api_gateway_domain_name.api_domain.cloudfront_domain_name}"
    zone_id    = "${aws_api_gateway_domain_name.api_domain.cloudfront_zone_id}"
  }
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.default_api.id}"
  stage_name  = "${var.stage_name}"
}

resource "aws_api_gateway_base_path_mapping" "api_base_path" {
  base_path   = ""
  api_id      = "${aws_api_gateway_rest_api.default_api.id}"
  stage_name  = "${var.api_name}"
  domain_name = "${aws_api_gateway_domain_name.api_domain.domain_name}"
}