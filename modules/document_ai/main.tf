resource "google_document_ai_processor" "processor" {
  location = "us"
  display_name = var.display_name
  type = var.processor_type
  project = var.project_id
}