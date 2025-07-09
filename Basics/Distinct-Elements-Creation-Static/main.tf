
## Set of disk names, whereby toset function automatically removes duplicates - therefore no explicit distinct needed.
## Set also can be used directly in for_each later.
## => https://developer.hashicorp.com/terraform/language/functions/toset
locals {
  unique_disk_names = toset([
    for key in ["V1.0", "V1.0"]
    : replace("codebeamer-appdisk-${key}", ".", "_")
    if key != ""
  ])
}

output "names" {
  value = local.unique_disk_names
}
