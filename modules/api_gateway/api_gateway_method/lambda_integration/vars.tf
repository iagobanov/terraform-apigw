variable "http_method" {
  default = "ANY"
  description = "POST, GET..."
}

variable "resource_id" {
  description = "Root ID value from your ApiGW"
}

variable "rest_api_id" {
  description = "The ID of the associated REST API"
}

variable "api_path" {}


variable "lambda_name" {
  description = "The ARN of the lambda to be used with the integration"
}


variable "type" {
  default = "AWS"
}

variable "api_key_required" {
  default = true
}


variable "add_permission" {
  default = true
}
