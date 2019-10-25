provider "aws" {
  region = "${module.environment.aws_region}"
}

//The key is like this because we alter with SED in the Jenkins Pipeline
terraform {
  backend "s3" {
    region  = "us-east-1"
    bucket  = "pi-tfstates"
    key     = "API-GW/pi-api-gw.tfstate"
    encrypt = true
  }
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