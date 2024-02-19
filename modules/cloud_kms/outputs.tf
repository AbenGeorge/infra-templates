output "keyring" {
  description = "Self link of the keyring."
  value       = length(google_kms_key_ring.key_ring) > 0 ?  google_kms_key_ring.key_ring[0].id : null

  depends_on = [
    google_kms_crypto_key_iam_binding.encrypters_decrypters,
  ]
}

output "keyring_resource" {
  description = "Keyring resource."
  value       = length(google_kms_key_ring.key_ring) > 0 ?  google_kms_key_ring.key_ring[0] : null

  depends_on = [
    google_kms_crypto_key_iam_binding.encrypters_decrypters,
  ]
}

# output "keys" {
#   description = "Map of key name => key self link."
#   value       = local.keys_by_name

#   depends_on = [
#     google_kms_crypto_key_iam_binding.owners,
#     google_kms_crypto_key_iam_binding.decrypters,
#     google_kms_crypto_key_iam_binding.encrypters,
#   ]
# }

output "keyring_name" {
  description = "Name of the keyring."
  value       = length(google_kms_key_ring.key_ring) > 0 ?  google_kms_key_ring.key_ring[0].name :null

  depends_on = [
    google_kms_crypto_key_iam_binding.encrypters_decrypters,
  ]
}

output "key_id" {
  description = "ID of the key"
  value = length(google_kms_crypto_key.key) > 0 ?  google_kms_crypto_key.key[0].id : length(google_kms_crypto_key.key_ephemeral) > 0 ?  google_kms_crypto_key.key_ephemeral[0].id : null 

  depends_on = [
   google_kms_crypto_key_iam_binding.encrypters_decrypters,
  ]
}

