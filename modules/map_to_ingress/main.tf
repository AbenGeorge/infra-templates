data "kubernetes_ingress" "https_target_proxy" {
    metadata {
        name = "${var.service}-ingress"
        namespace = var.namespace
        annotations = {
          "ingress.kubernetes.io/https-target-proxy" = ""
        }
    }
}

# resource "google_compute_target_https_proxy" "default" {
#   name             = data.kubernetes_ingress.https_target_proxy.metadata.annotations
#   url_map          = google_compute_url_map.default.id
#   ssl_certificates = [google_compute_ssl_certificate.default.id]
# }