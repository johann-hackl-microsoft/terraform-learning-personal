terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}


variable "pod_managed_identities" {
  description = "A map of Pod managed identity configurations"
  type = map(object({
    resource_group_name = string
    location            = string
    federated_credentials = list(object({
      name                      = string
      pod_workload_sa_namespace = string
      pod_workload_sa_name      = string
      resource_group_name       = string
    }))
  }))
}

resource "random_pet" "rg_name" {
  for_each = {
      for element in flatten([
        for id_key, id_value in var.pod_managed_identities : [
          for credential in id_value.federated_credentials :
            {
              unique_key = "${id_key}_${credential.name}"
              id_key = id_key
              identity = id_value
              credential = credential
            }
        ]
    ])
    : element.unique_key => element 
  }

  prefix = "${each.value.id_key}/${each.value.credential.name}"
}

# terraform plan --var-file=test.tfvars