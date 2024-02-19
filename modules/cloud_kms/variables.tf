variable "project_id" {
  description = "Project id where the keyring will be created."
  type        = string
}

variable "location" {
  description = "Location for the keyring."
  type        = string
}

variable "new_ring" {
  description = "Checks if a new keyring needs to be created"
  type = bool
}
variable "keyring" {
  description = "Keyring name."
  type        = string
}

variable "keys" {
  description = "Key names."
  type        = string
  default     = ""
}

variable "prevent_destroy" {
  description = "Set the prevent_destroy lifecycle attribute on keys."
  type        = bool
  default     = true
}

variable "purpose" {
  type        = string
  description = "The immutable purpose of the CryptoKey. Possible values are ENCRYPT_DECRYPT, ASYMMETRIC_SIGN, and ASYMMETRIC_DECRYPT."
  default     = "ENCRYPT_DECRYPT"
}


variable "encrypters_decrypters" {
  description = "List of comma-separated owners for each key declared in set_encrypters_for."
  type        = set(string)
  default     = []
}


variable "key_rotation_period" {
  description = "Generate a new key every time this period passes."
  type        = string
  default     = "100000s"
}

variable "key_algorithm" {
  type        = string
  description = "The algorithm to use when creating a version based on this template. See the https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm for possible inputs."
  default     = "GOOGLE_SYMMETRIC_ENCRYPTION"
}

variable "key_protection_level" {
  type        = string
  description = "The protection level to use when creating a version based on this template. Default value: \"SOFTWARE\" Possible values: [\"SOFTWARE\", \"HSM\"]"
  default     = "SOFTWARE"
}

variable "labels" {
  type        = map(string)
  description = "Labels, provided as a map"
  default     = {}
}