data "aws_acm_certificate" "aws_pi" {
  domain      = "soupi.com.br"
  statuses    = ["ISSUED"]
  most_recent = true
}