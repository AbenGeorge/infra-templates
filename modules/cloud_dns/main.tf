# data "kubernetes_resource" "example" {
#   api_version    = "gateway.networking.k8s.io/v1beta1"
#   kind           = "Gateway"
#   metadata {
#     name = "external_http"
#   }

# }

data "external" "gateway_ip" {
  program = ["/bin/bash", "../shell-scripts/gateway_ip.sh" , "-g external-http", "-p ${var.project_id}", "-r ${var.location}", "-c ${var.cluster_name}"] 
  working_dir = "${path.module}/.."
  query = {
    output_file = "output.txt"
    error_file  = "error.txt"
  }
}

resource "google_dns_managed_zone" "example-zone" {
  project = var.project_id
  name        = "test-zone"
  dns_name    = "${var.dns_name}."
  labels = var.dns_labels
  description = "Testing DNS zone for ${var.dns_name}"
}

resource "google_dns_record_set" "frontend" {
  name = "${var.record_set_name}.${google_dns_managed_zone.example-zone.dns_name}"
  project = var.project_id
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.example-zone.name

  rrdatas = [ "${data.external.gateway_ip.result["gateway_ip"]}" ]

  depends_on = [ google_dns_managed_zone.example-zone ]
}
