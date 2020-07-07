provider "aws" {
  region = "${module.environment.aws_region}"
}

//The key is like this because we alter with SED in the Jenkins Pipeline
terraform {
  backend "s3" {
    region  = "us-east-1"
    bucket  = ""
    key     = "resources.tfstate"
    encrypt = true
  }
}

module "environment" {
  source = "../../"
}

module "aws_api_gateway_resource" {
  source      = "../../../../../../../../modules/api_gateway/api_gateway_resource"
  rest_api_id = "${module.environment.rest_api_id}"
  parent_id   = "${module.environment.api_parent_id}"
  path_part   = "${var.path_part}"
}

module "aws_api_gateway_resource_proxy" {
  source      = "../../../../../../../../modules/api_gateway/api_gateway_resource"
  rest_api_id = "${module.environment.rest_api_id}"
  parent_id   = "${module.aws_api_gateway_resource.parent_id}"
  path_part   = "{proxy+}"
}

module "aws_api_gateway_method" {
  source           = "../../../../../../../../modules/api_gateway/api_gateway_method/http_integration"
  rest_api_id      = "${module.environment.rest_api_id}"
  resource_id      = "${module.aws_api_gateway_resource_proxy.parent_id}"
  http_method      = "${var.http_method}"
  type             = "${var.type}"
  endpoint         = "${var.endpoint}"
  api_key_required = "${var.api_key_required}"
  path_part        = "${var.path_part}"
}

module "aws_api_gateway_method_proxy_get" {
  source           = "../../../../../../../../modules/api_gateway/api_gateway_method/http_integration"
  rest_api_id      = "${module.environment.rest_api_id}"
  resource_id      = "${module.aws_api_gateway_resource_proxy.parent_id}"
  http_method      = "GET"
  type             = "${var.type}"
  endpoint         = "${var.endpoint}"
  api_key_required = "${var.api_key_required}"
  path_part        = "${var.path_part}"
}

#### Lambda movimentofinanceiro ####
module "aws_api_gateway_resource_movimentofinanceiro" {
  source      = "../../../../../../../../modules/api_gateway/api_gateway_resource"
  rest_api_id = "${module.environment.rest_api_id}"
  parent_id   = "${module.aws_api_gateway_resource.parent_id}"
  path_part   = "movimentofinanceiro"
}

module "aws_api_gateway_method_movimentofinanceiro" {
  source         = "../../../../../../../../modules/api_gateway/api_gateway_method/lambda_integration"
  rest_api_id    = "${module.environment.rest_api_id}"
  resource_id    = "${module.aws_api_gateway_resource_movimentofinanceiro.parent_id}"
  api_path       = "movimentofinanceiro"
  http_method    = "POST"
  type           = "AWS_PROXY"
  lambda_name    = "sendFinancialMovement"
  add_permission = true
}

#### Lambda status ####

module "aws_api_gateway_resource_status" {
  source      = "../../../../../../../../modules/api_gateway/api_gateway_resource"
  rest_api_id = "${module.environment.rest_api_id}"
  parent_id   = "${module.aws_api_gateway_resource.parent_id}"
  path_part   = "status"
}

module "aws_api_gateway_resource_trata_queue_core_status_ordem" {
  source      = "../../../../../../../../modules/api_gateway/api_gateway_resource"
  rest_api_id = "${module.environment.rest_api_id}"
  parent_id   = "${module.aws_api_gateway_resource_status.parent_id}"
  path_part   = "trata-queue-core-status-ordem"
}

module "aws_api_gateway_method_trata_queue_core_status_ordem" {
  source         = "../../../../../../../../modules/api_gateway/api_gateway_method/lambda_integration"
  rest_api_id    = "${module.environment.rest_api_id}"
  resource_id    = "${module.aws_api_gateway_resource_trata_queue_core_status_ordem.parent_id}"
  api_path       = "trata-queue-core-status-ordem"
  http_method    = "POST"
  type           = "AWS_PROXY"
  lambda_name    = "consolidaStatusOrdem-ApiSouPi-trataQueueCoreStatusOrdem"
  add_permission = true
}

module "aws_api_gateway_resource_trata-queue-core-status-r1" {
  source      = "../../../../../../../../modules/api_gateway/api_gateway_resource"
  rest_api_id = "${module.environment.rest_api_id}"
  parent_id   = "${module.aws_api_gateway_resource_status.parent_id}"
  path_part   = "trata-queue-core-status-r1"
}

module "aws_api_gateway_method_trata-queue-core-status-r1" {
  source         = "../../../../../../../../modules/api_gateway/api_gateway_method/lambda_integration"
  rest_api_id    = "${module.environment.rest_api_id}"
  resource_id    = "${module.aws_api_gateway_resource_trata-queue-core-status-r1.parent_id}"
  api_path       = "trata-queue-core-status-r1"
  http_method    = "POST"
  type           = "AWS_PROXY"
  lambda_name    = "consolidaStatusOrdem-ApiSouPi-trataQueueCoreStatusR1"
  add_permission = true
}

#### Lambda tesouroDiretoInvestments ####

module "aws_api_gateway_resource_tesouroDiretoInvestments" {
  source      = "../../../../../../../../modules/api_gateway/api_gateway_resource"
  rest_api_id = "${module.environment.rest_api_id}"
  parent_id   = "${module.aws_api_gateway_resource.parent_id}"
  path_part   = "tesouroDiretoInvestments"
}

module "aws_api_gateway_method_tesouroDiretoInvestments" {
  source         = "../../../../../../../../modules/api_gateway/api_gateway_method/lambda_integration"
  rest_api_id    = "${module.environment.rest_api_id}"
  resource_id    = "${module.aws_api_gateway_resource_tesouroDiretoInvestments.parent_id}"
  api_path       = "tesouroDiretoInvestments"
  http_method    = "POST"
  type           = "AWS_PROXY"
  lambda_name    = "tesourodiretoinvestiments"
  add_permission = true
}


#### Lambda tesouroDiretoListClient ####

module "aws_api_gateway_resource_tesouroDiretoListClient" {
  source      = "../../../../../../../../modules/api_gateway/api_gateway_resource"
  rest_api_id = "${module.environment.rest_api_id}"
  parent_id   = "${module.aws_api_gateway_resource.parent_id}"
  path_part   = "tesouroDiretoListClient"
}

module "aws_api_gateway_method_tesouroDiretoListClient" {
  source         = "../../../../../../../../modules/api_gateway/api_gateway_method/lambda_integration"
  rest_api_id    = "${module.environment.rest_api_id}"
  resource_id    = "${module.aws_api_gateway_resource_tesouroDiretoListClient.parent_id}"
  api_path       = "tesouroDiretoListClient"
  http_method    = "POST"
  type           = "AWS_PROXY"
  lambda_name    = "tesouroDiretoListClient"
  add_permission = true
}

#### Lambda v2 ####

module "aws_api_gateway_resource_v2" {
  source      = "../../../../../../../../modules/api_gateway/api_gateway_resource"
  rest_api_id = "${module.environment.rest_api_id}"
  parent_id   = "${module.aws_api_gateway_resource.parent_id}"
  path_part   = "v2"
}

module "aws_api_gateway_resource_v2_proxy" {
  source      = "../../../../../../../../modules/api_gateway/api_gateway_resource"
  rest_api_id = "${module.environment.rest_api_id}"
  parent_id   = "${module.aws_api_gateway_resource_v2.parent_id}"
  path_part   = "{proxy+}"
}

module "aws_api_gateway_method_v2" {
  source         = "../../../../../../../../modules/api_gateway/api_gateway_method/lambda_integration"
  rest_api_id    = "${module.environment.rest_api_id}"
  resource_id    = "${module.aws_api_gateway_resource_v2_proxy.parent_id}"
  api_path       = "{proxy+}"
  http_method    = "POST"
  type           = "AWS_PROXY"
  lambda_name    = "posicao-int-consulta"
  add_permission = true
}

##### SQS quecarccocontacorrente #####

module "aws_api_gateway_resource_sqs-filas" {
  source      = "../../../../../../../../modules/api_gateway/api_gateway_resource"
  rest_api_id = "${module.environment.rest_api_id}"
  parent_id   = "${module.aws_api_gateway_resource.parent_id}"
  path_part   = "sqs-filas"
}

module "aws_api_gateway_resource_quecarccocontacorrente" {
  source      = "../../../../../../../../modules/api_gateway/api_gateway_resource"
  rest_api_id = "${module.environment.rest_api_id}"
  parent_id   = "${module.aws_api_gateway_resource_sqs-filas.parent_id}"
  path_part   = "quecarccocontacorrente"
}

module "aws_api_gateway_method_quecarccocontacorrente" {
  source            = "../../../../../../../../modules/api_gateway/api_gateway_method/sqs_integration"
  auto_send_message = false
  rest_api_id       = "${module.environment.rest_api_id}"
  resource_id       = "${module.aws_api_gateway_resource_quecarccocontacorrente.parent_id}"
  api_path          = "quecarccocontacorrente"
  http_method       = "POST"
  type              = "AWS"
  sqs_name          = "queCarCcoContacorrenteQueue"

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }
}


##### SQS  #####


module "aws_api_gateway_resource_quecaromslimiteoperacional" {
  source      = "../../../../../../../../modules/api_gateway/api_gateway_resource"
  rest_api_id = "${module.environment.rest_api_id}"
  parent_id   = "${module.aws_api_gateway_resource_sqs-filas.parent_id}"
  path_part   = "quecaromslimiteoperacional"
}

module "aws_api_gateway_method_quecaromslimiteoperacional" {
  source            = "../../../../../../../../modules/api_gateway/api_gateway_method/sqs_integration"
  auto_send_message = false
  rest_api_id       = "${module.environment.rest_api_id}"
  resource_id       = "${module.aws_api_gateway_resource_quecaromslimiteoperacional.parent_id}"
  api_path          = "quecaromslimiteoperacional"
  http_method       = "POST"
  type              = "AWS"
  sqs_name          = "queCarOmsLimiteOperacional_queue"

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }
} 
