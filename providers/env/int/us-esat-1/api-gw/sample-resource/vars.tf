variable "path_part" {
  description = "Name of your API GW Resource"
  default     = "sample-resource"
}

variable "http_method" {
  default     = "POST"
  description = "POST, GET..."
}

variable "api_path" {
  default = "sample-resource"
}

variable "lambda_name" {
  description = "The ARN of the lambda to be used with the integration"
  default     = "my_lambda_arn_if_needed"
}

variable "type" {
  description = "Type of integration. User HTTP_PROXY for containert and AWS_PROXY for lambda"
  default     = "HTTP_PROXY"
}

variable "endpoint" {
  default = "https://my_endpoint.com"
}

variable "api_key_required" {
  default = true
}

