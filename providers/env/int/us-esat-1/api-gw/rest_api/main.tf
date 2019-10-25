provider "aws" {
  region = "${module.environment.aws_region}"
}

module "environment" {
  source = "../"
}


module "api_gateway" {
  source          = "../../../../../../../modules/api_gateway/api_gateway_rest_api"
  api_name        = "${var.api_name}"
  zone_id         = "${module.environment.zone_id}"
  api_domain_name = "${var.api_domain_name}"
  stage_name      = "${var.api_name}"
}