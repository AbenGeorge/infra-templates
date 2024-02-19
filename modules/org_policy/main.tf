locals {
  # organization_id = split("organizations/", var.organization_id)[1]
  boolean_policy  = var.policy_type == "bool"
  restore_policy  = var.policy_type == "restore"
  list_policy     = var.policy_type == "list" && (var.policy_list_type == "allow" || var.policy_list_type == "deny")
}

# resource "google_organization_policy" "org_policy" {
#   org_id     = local.organization_id
#   constraint = var.policy_constraint

#   dynamic "restore_policy" {
#     for_each = local.restore_policy ? [true] : []

#     content {
#       default = restore_policy.value
#     }
#   }

#   dynamic "boolean_policy" {
#     for_each = local.boolean_policy ? [var.policy_bool_value] : []

#     content {
#       enforced = boolean_policy.value
#     }
#   }

#   dynamic "list_policy" {
#     for_each = local.list_policy ? [var.policy_list_type] : []

#     content {

#       dynamic "allow" {
#         for_each = list_policy.value == "allow" ? [true] : []

#         content {
#           all    = var.policy_list_values == null ? allow.value : null
#           values = var.policy_list_values != null && can(length(var.policy_list_values) > 0) ? var.policy_list_values : null
#         }
#       }

#       dynamic "deny" {
#         for_each = list_policy.value == "deny" ? [true] : []

#         content {
#           all    = var.policy_list_values == null ? deny.value : null
#           values = var.policy_list_values != null && can(length(var.policy_list_values) > 0) ? var.policy_list_values : null
#         }
#       }
#     }
#   }
# }


resource "google_org_policy_policy" "org_policy" {
  name = format("%s/policies/%s",var.parent,var.policy_constraint)
  parent = var.parent
  spec {
    reset = local.restore_policy ? true : null
    inherit_from_parent = local.restore_policy ? false : null
    dynamic "rules" {
      for_each = local.restore_policy ? []:[1]
      content {
        enforce = local.boolean_policy ? var.policy_bool_value : null
        allow_all = var.policy_list_type == "allow" && var.policy_list_values == null ? true : null
        deny_all = var.policy_list_type == "deny" && var.policy_list_values == null ? true : null
        values {
          allowed_values = var.policy_list_type == "allow" && var.policy_list_values != null && can(length(var.policy_list_values) > 0)? var.policy_list_values : null
          denied_values = var.policy_list_type == "deny" && var.policy_list_values != null && can(length(var.policy_list_values) > 0)? var.policy_list_values : null
        }
      }
    }
  }
}
