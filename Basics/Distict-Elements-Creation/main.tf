## Optional variables
variable "codebeamer_cb_version" {
  type        = string
  description = "Version of codebeamer_cb"
  default     = ""
}

variable "setup_cb_version" {
  type        = string
  description = "Version of setup_cb"
  default     = ""
}

## Set of disk names, whereby toset function automatically removes duplicates - therefore no explicit distinct needed.
## Set also can be used directly in for_each later.
## => https://developer.hashicorp.com/terraform/language/functions/toset
locals {
  unique_disk_names = toset([
    for key in [var.codebeamer_cb_version, var.setup_cb_version]
    : replace("codebeamer-appdisk-${key}", ".", "_")
    if key != ""
  ])
}

# Create local files for each disk name
# => Dummy to be able to test logic locally without any Azure subscription.
# => Should work the same for azurerm_managed_disk instead.
resource "local_file" "foo" {
  for_each = local.unique_disk_names

  content  = ""
  filename = "${path.module}/${each.key}.txt"
}
