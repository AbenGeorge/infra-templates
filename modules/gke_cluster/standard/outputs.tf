output "name" {
  value = google_container_cluster.gke_cluster.name
}

output "location" {
  value = google_container_cluster.gke_cluster.location
}

output "project" {
  value = google_container_cluster.gke_cluster.project
}

output "endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate
}

