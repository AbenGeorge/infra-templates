output "key_id" {
  value = data.google_kms_crypto_key_version.key[0].id
}

