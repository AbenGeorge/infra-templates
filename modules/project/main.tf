locals {
  iam_bindings = flatten([
    for member in var.iam_bindings: [
      for roles in member.roles: {
        member = member.member
        role = roles
      }
    ]
  ])
}

resource "google_project" "project" {
  project_id          = var.project_id
  name                = var.project_name != null && var.project_name != "" ? var.project_name : var.project_id
  org_id              = split("/", var.project_parent)[0] == "organizations" ? split("/", var.project_parent)[1] : null
  folder_id           = split("/", var.project_parent)[0] == "folders" ? split("/", var.project_parent)[1] : null
  billing_account     = var.billing_account
  auto_create_network = var.auto_create_network
  labels              = var.project_labels

  timeouts {
    create = "30m"
    update = "40m"
  }
}



resource "google_project_service" "service" {
  for_each = can(length(var.project_services) > 0) ? toset(var.project_services) : []

  project  =var.project_id
  service                    = each.value
  disable_dependent_services = true

  timeouts {
    create = "30m"
    update = "40m"
  }
}


# resource "google_project_iam_binding" "iam_policy_binding" {
#   for_each = { for iam_binding in var.iam_bindings : iam_binding.role => iam_binding }

#   project  = var.project_id
#   role    = each.value.role
#   members = each.value.members

#   depends_on = [
#     google_project_service.service
#   ]
# }

resource "google_project_iam_member" "iam_policy_binding" {
  for_each = { for no, members in local.iam_bindings : no => members }

  project  = var.project_id
  role    = each.value.role
  member = length(regexall(".*gserviceaccount.*",each.value.member)) > 0 ? "serviceAccount:${each.value.member}" : "user:${each.value.member}"

  depends_on = [
    google_project_service.service
  ]
}
