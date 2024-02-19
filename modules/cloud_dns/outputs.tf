output "dns" {
  value = data.external.gateway_ip.result["gateway_ip"]
}