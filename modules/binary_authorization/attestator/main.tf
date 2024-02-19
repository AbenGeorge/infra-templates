data "google_kms_crypto_key_version" "key" {
  count = var.enable_binary_authorization ? 1 : 0 
  crypto_key = var.kms_crypto_key_version_id
}

resource "google_binary_authorization_attestor" "attestor" {
  count = var.enable_binary_authorization ? 1 : 0 
  project = var.project_id
  name    = "${var.attestor-name}-attestor"
  attestation_authority_note {
    note_reference = google_container_analysis_note.build-note[0].name
    public_keys {
      id = data.google_kms_crypto_key_version.key[0].id
      pkix_public_key {
        public_key_pem      = data.google_kms_crypto_key_version.key[0].public_key[0].pem
        signature_algorithm = data.google_kms_crypto_key_version.key[0].public_key[0].algorithm
      }
    }
  }
  depends_on = [
    google_container_analysis_note.build-note
  ]
}

resource "google_container_analysis_note" "build-note" {
  count = var.enable_binary_authorization ? 1 : 0 
  project = var.project_id
  name    = "${var.attestor-name}-attestor-note"
  attestation_authority {
    hint {
      human_readable_name = "${var.attestor-name} Attestor"
    }
  }
}

resource "google_binary_authorization_policy" "policy" {
  count = var.enable_binary_authorization ? 1 : 0 
  admission_whitelist_patterns {
    name_pattern = "gcr.io/google_containers/*"
  }

  default_admission_rule {
    evaluation_mode  = var.evaluation_mode
    enforcement_mode = var.enforcement_mode
    require_attestations_by = [ google_binary_authorization_attestor.attestor[0].name ]
  }

  cluster_admission_rules {
    cluster                 = format("%s.%s", var.location, var.gke_cluster)
    evaluation_mode         = var.cluster_evaluation_mode
    enforcement_mode        = var.cluster_enforcement_mode
    require_attestations_by = [google_binary_authorization_attestor.attestor[0].name]
  }

  global_policy_evaluation_mode = var.global_policy_evaluation_mode
  project = var.project_id
  depends_on = [
    google_binary_authorization_attestor.attestor
  ]
}