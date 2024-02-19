resource "kubectl_manifest" "manifest_deployment" {
  for_each = {
    for idx, content in split("\n---", var.yaml_body) : idx => content
  }
  yaml_body = each.value
}