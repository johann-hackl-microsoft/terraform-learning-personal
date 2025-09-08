# Input: required patching as map
variable "patch_listener_hostnames" {
  type = map(set(string))
  default = {
    "private-listener-0-443" = ["new-private-listener-0-443.cloud.somewhere.com", "additional-hostname.com"]
    "DISABLED-private-http-redirect-listener-0-80" = ["new-redirect-listener.cloud.somewhere.com"]
  }
}

# Processing: patch entries of input_list_listener.json according the patch_listener_hostnames:
# - if the name of an entry exists as a key in patch_listener_hostnames, use the hostNames property from the patch_listener_hostnames map
locals {
  input_list = jsondecode(file("${path.module}/input_list_listener.json"))

  updated_list = [
    for item in local.input_list : merge(
      item,
      contains(keys(var.patch_listener_hostnames), item.name) ? {
        properties = merge(
          item.properties,
          {
            hostNames = var.patch_listener_hostnames[item.name]
          }
        )
      } : {}
    )
  ]
}

# Outputs to verify the changes
output "patched_input_list" {
  value = local.updated_list
}

output "listener_names_and_hostnames" {
  description = "Summary of listener names and their hostnames"
  value = {
    for item in local.updated_list : item.name => item.properties.hostNames
  }
}