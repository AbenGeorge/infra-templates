resource "google_storage_bucket" "storage_bucket" {
  project       = var.project_id
  name          = var.name
  location      = var.location
  storage_class = var.storage_class
  force_destroy = var.force_destroy
  public_access_prevention = var.public_access_prevention
  uniform_bucket_level_access = var.uniform_bucket_level_access

  dynamic "encryption" {
    for_each = var.encryption == null ? [] : [var.encryption]
    content {
      default_kms_key_name = var.encryption.default_kms_key_name
    }
  }

  versioning {
    enabled = var.versioning != null && var.versioning != "" ? var.versioning : false
  }

 dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
      condition {
        age                        = lookup(lifecycle_rule.value.condition, "age", null)
        created_before             = lookup(lifecycle_rule.value.condition, "created_before", null)
        with_state                 = lookup(lifecycle_rule.value.condition, "with_state", lookup(lifecycle_rule.value.condition, "is_live", false) ? "LIVE" : null)
        matches_storage_class      = contains(keys(lifecycle_rule.value.condition), "matches_storage_class") ? split(",", lifecycle_rule.value.condition["matches_storage_class"]) : null
        matches_prefix             = contains(keys(lifecycle_rule.value.condition), "matches_prefix") ? split(",", lifecycle_rule.value.condition["matches_prefix"]) : null
        matches_suffix             = contains(keys(lifecycle_rule.value.condition), "matches_suffix") ? split(",", lifecycle_rule.value.condition["matches_suffix"]) : null
        num_newer_versions         = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
        custom_time_before         = lookup(lifecycle_rule.value.condition, "custom_time_before", null)
        days_since_custom_time     = lookup(lifecycle_rule.value.condition, "days_since_custom_time", null)
        days_since_noncurrent_time = lookup(lifecycle_rule.value.condition, "days_since_noncurrent_time", null)
        noncurrent_time_before     = lookup(lifecycle_rule.value.condition, "noncurrent_time_before", null)
      }
    }
  }
}

resource "google_storage_bucket_iam_binding" "binding" {

  bucket = google_storage_bucket.storage_bucket.name
  role = "roles/storage.admin"
  members = [
    "serviceAccount:${var.google_storage_sa}",
  ]

  depends_on = [ 
    google_storage_bucket.storage_bucket
   ]
  
}



resource "google_storage_bucket_object" "object" {
  for_each = var.object != 0 ? { for object in var.object : object.object_name  => object  } : {}
  name   = each.value.object_name
  bucket = google_storage_bucket.storage_bucket.id
  kms_key_name = var.encryption.default_kms_key_name
  temporary_hold = var.temporary_hold
  # customer_encryption {
  #   encryption_algorithm = var.encryptio
  #   encryption_key =  
  # }
  source = each.value.object_source  # Add path to the zipped source code

  depends_on = [ 
    google_storage_bucket.storage_bucket 
  ]
}