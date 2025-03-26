
provider "azurerm" {
  features {}
}

# provider "azuread" {}

data "azurerm_subscription" "current" {}

# Generate a unique identifier for each app registration
resource "random_uuid" "app_id" {
  for_each = { for ws in var.tfc_configs : ws.app_name => ws }
}

resource "azuread_application" "tfc_application" {
  for_each     = { for ws in var.tfc_configs : ws.app_name => ws }
  display_name = "${each.value.app_name}-${random_uuid.app_id[each.key].result}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azuread_service_principal" "tfc_service_principal" {
  for_each       = azuread_application.tfc_application
  application_id = each.value.application_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "azuread_application_federated_identity_credential" "tfc_federated_credentials" {
  for_each = { for ws in var.tfc_configs : ws.app_name => ws }

  application_object_id = azuread_application.tfc_application[each.key].object_id
  display_name          = "tfc-federated-credential-${each.value.workspace_name}-${random_uuid.app_id[each.key].result}"
  audiences             = ["api://AzureAD"]
  issuer                = "https://app.terraform.io"
  subject               = "organization:${each.value.organization_name}:project:${each.value.project_name}:workspace:${each.value.workspace_name}:run_phase:*"

  lifecycle {
    create_before_destroy = true
  }
}

/* resource "azuread_application_federated_identity_credential" "tfc_federated_credential_apply" {
  application_object_id = azuread_application.tfc_application[each.key].object_id
  display_name          = "tfc-federated-credential-apply-${each.value.workspace_name}-${random_uuid.app_id[each.key].result}"
  audiences             = ["api://AzureAD"]
  issuer                = "https://app.terraform.io"
  subject               = "organization:${each.value.organization_name}:project:${each.value.project_name}:workspace:${each.value.workspace_name}:run_phase:apply"

  lifecycle {
    create_before_destroy = true
  }
} */

resource "azurerm_role_assignment" "tfc_role_assignment" {
  for_each             = azuread_service_principal.tfc_service_principal
  scope                = data.azurerm_subscription.current.id
  principal_id         = each.value.object_id
  role_definition_name = "Contributor"

  lifecycle {
    create_before_destroy = true
  }
}
