provider "aws" {
  region = "${module.environment.aws_region}"
}

module "environment" {
  source = "../../"
}

module "api_gateway_key" {
  source          = "../../../../../../../modules/api_gateway/api_gateway_key"
  api_key_name    = "${var.api_gateway_key_name}"
  api_id          = "${module.environment.rest_api_id}"
  stage_name      = "${var.stage_name}"
}
