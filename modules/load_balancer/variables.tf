#Global
variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "project" {}
variable "env" {}

variable "zone" {
  description = "Google Cloud zone"
  type        = string
  default     = "europe-west2-a"
}

############################
# Load Balancer variables #
############################
variable "name" {
  type        = string
  description = "Instance group name."
  default     = ""
}

variable "instance_id" {
  type        = string
  description = "Instance ID of the instance that needs to be a part of instance group."
  default     = ""
}

variable "named_port" {
  type        = map(string)
  description = "Named port for the instance group."
  default     = {}
}

variable "port_range" {
  type        = number
  description = "Port range for LB frontend."
}

variable "health_check_port" {
  type        = number
  description = "The TCP port number for the TCP health check request."
}

variable "port_name" {
  type        = string
  description = "Name of backend port. The same name should appear in the instance groups referenced by this service."
  default     = ""
}

# variable "request_headers" {
#   type        = string
#   description = "Headers that the HTTP/S load balancer should add to proxied requests."
# }

variable "certificate_map" {
  type        = string
  description = "SSL certificate map."
  default     = ""
}

variable "ssl_policy" {
  type        = string
  description = "SSL policy"
  default     = ""
}

variable "domain_name" {
  type        = string
  description = "The domain name"
  default     = ""
}
