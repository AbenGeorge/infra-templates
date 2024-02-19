variable "project_id" {
  type        = string
  description = "Project ID to apply services into"
}

variable "enable_binary_authorization" {
  type = bool
  default = true
}

variable "attestor-name" {
  type        = string
  description = "Name of the attestor"
}

variable "kms_crypto_key_version_id" {
  type = string
  description = "The ID of the Cloud KMS crypto key version"
}

variable "evaluation_mode" {
  type = string
  description = "How this admission rule will be evaluated. Possible values: [ALWAYS_ALLOW, REQUIRE_ATTESTATION, ALWAYS_DENY]"
  default = "REQUIRE_ATTESTATION"
}

variable "enforcement_mode" {
  type = string
  description = "The action when a pod creation is denied by the admission rule. Possible values: [ENFORCED_BLOCK_AND_AUDIT_LOG, DRYRUN_AUDIT_LOG_ONLY]"
  default = "ENFORCED_BLOCK_AND_AUDIT_LOG"
}

variable "gke_cluster" {
  type = string
  description = "The GKE cluster to which the binary authorization policy is applied"
  default = null
}

variable "cluster_evaluation_mode" {
  type = string
  description = "How this admission rule will be evaluated. Possible values: [ALWAYS_ALLOW, REQUIRE_ATTESTATION, ALWAYS_DENY]"
  default = "REQUIRE_ATTESTATION"
}

variable "cluster_enforcement_mode" {
  type = string
  description = "The action when a pod creation is denied by the admission rule. Possible values: [ENFORCED_BLOCK_AND_AUDIT_LOG, DRYRUN_AUDIT_LOG_ONLY]"
  default = "ENFORCED_BLOCK_AND_AUDIT_LOG"
}

variable "global_policy_evaluation_mode" {
  type = string
  description = "Controls the evaluation of a Google-maintained global admission policy for common system-level images. Images not covered by the global policy will be subject to the project admission policy. Possible values: [ENABLE, DISABLE]"
  default = "ENABLE"
}

variable "location" {
  description = "The location where can GKE cluster can be created."
  type        = string
}