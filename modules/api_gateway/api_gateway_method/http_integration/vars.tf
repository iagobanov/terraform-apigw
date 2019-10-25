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


variable "type" {
  default = "HTTP_PROXY"
}

variable "endpoint" {
  default = ""
}

variable "api_key_required" {
  default = true
}

variable "path_part" {}
