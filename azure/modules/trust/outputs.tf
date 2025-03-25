output "subscription_id" {
  description = "Azure subscription ID"
  value       = data.azurerm_subscription.current.subscription_id
}

output "tenant_id" {
  description = "Azure tenant ID"
  value       = data.azurerm_subscription.current.tenant_id
}

/* output "run_client_id" {
  description = "Client ID for trust relationship"
  value       = azuread_application.tfc_application.application_id
}

output "openid_claims" {
  description = "OpenID Claims for trust relationship"
  value = [
    azuread_application_federated_identity_credential.tfc_federated_credential_plan.subject,
    azuread_application_federated_identity_credential.tfc_federated_credential_apply.subject,
  ]
} */

output "azuread_applications" {
  description = "List of created Azure AD Applications"
  value = {
    for app_name, app in azuread_application.tfc_application :
    app_name => {
      application_id = app.application_id
      display_name   = app.display_name
      object_id      = app.object_id
    }
  }
}

output "azuread_service_principals" {
  description = "List of created Service Principals"
  value = {
    for app_name, sp in azuread_service_principal.tfc_service_principal :
    app_name => {
      principal_id   = sp.object_id
      application_id = sp.application_id
    }
  }
}

output "federated_identity_credentials" {
  description = "Federated Identity Credentials for Terraform Cloud"
  value = {
    for app_name, credential in azuread_application_federated_identity_credential.tfc_federated_credentials :
    app_name => {
      display_name = credential.display_name
      issuer       = credential.issuer
      subject      = credential.subject
    }
  }
}

output "role_assignments" {
  description = "Role assignments for each service principal"
  value = {
    for app_name, role in azurerm_role_assignment.tfc_role_assignment :
    app_name => {
      scope        = role.scope
      role_name    = role.role_definition_name
      principal_id = role.principal_id
    }
  }
}
