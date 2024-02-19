variable "ssl_cert_name" {
  type = string
  description = "The name of the SSL certificate"
}

variable "cert_domains" {
  type = list(string)
  description = "The list of domains secured by the ssl certificate"
}

variable "project_id" {
  type = string
  description = "The project in which the SSL certificate is configured"
}