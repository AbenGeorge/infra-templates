
# locals {
#   keys_by_name = zipmap(var.keys, var.prevent_destroy ? slice(google_kms_crypto_key.key[*].id, 0, length(var.keys)) : slice(google_kms_crypto_key.key_ephemeral[*].id, 0, length(var.keys)))
# }

resource "google_kms_key_ring" "key_ring" {
  count = var.new_ring ? 1 : 0
  name     = var.keyring
  project  = var.project_id
  location = var.location
}

resource "time_sleep" "wait_40_seconds" {
  create_duration = "40s"
  depends_on = [ 
    google_kms_key_ring.key_ring
   ]
}

# data "google_kms_key_ring" "key_ring" {
#   count = var.new_ring ? 0 : 1
#   name = var.keyring
#   project = var.project_id
#   location = var.location
# }

resource "google_kms_crypto_key" "key" {
  count           = var.prevent_destroy ? 1 : 0
  name            = var.keys
  key_ring        = var.new_ring  ? google_kms_key_ring.key_ring[0].id : var.keyring 
  rotation_period = var.key_rotation_period
  purpose         = var.purpose

  lifecycle {
    prevent_destroy = true
  }


  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.labels

  depends_on = [ 
    time_sleep.wait_40_seconds
   ]
}

resource "google_kms_crypto_key" "key_ephemeral" {
  count           = var.prevent_destroy ? 0 : 1
  name            = var.keys
  key_ring        = var.new_ring  ? google_kms_key_ring.key_ring[0].id : var.keyring 
  rotation_period = var.purpose != "ASYMMETRIC_SIGN" ? var.key_rotation_period : null
  purpose         = var.purpose

  lifecycle {
    prevent_destroy = false
  }

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.labels

  depends_on = [ 
    time_sleep.wait_40_seconds
   ]
  timeouts {
    create = "5m"
    update = "5m"
  }
}


resource "google_kms_crypto_key_iam_binding" "encrypters_decrypters" {
  count         = var.prevent_destroy ? length(google_kms_crypto_key.key) : length(google_kms_crypto_key.key_ephemeral)
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  crypto_key_id = var.prevent_destroy ? google_kms_crypto_key.key[count.index].id : google_kms_crypto_key.key_ephemeral[count.index].id
  members       =  var.encrypters_decrypters

  depends_on = [ 
    google_kms_crypto_key.key,
    google_kms_crypto_key.key_ephemeral
   ]
}

