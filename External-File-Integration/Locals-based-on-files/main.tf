variable "environment" {
  type = string
  default = "dev"
}

locals {
    base_path = abspath("${path.module}/config/${var.environment}")

    # flat list of distinct subdirectory names
    subdirectory_list = tolist(distinct([
                            for path in fileset(local.base_path, "*/*") :                             
                                dirname(path)
                        ]))
    # map of subdirectory names vs. absolute path, for easier later processing
    subdirectory_map = tomap({
                            for d in local.subdirectory_list:
                                d => join("/", [abspath(local.base_path), d])
                        })

    instances = tomap({for name, path in local.subdirectory_map: 
                        name => merge(
                                    {
                                        codebeamer_version = file(join("/", [path, "codebeamer.version"]))
                                    },
                                    tomap(
                                        jsondecode(coalesce(fileexists(join("/", [path, "vm-profile.json"])) ? file(join("/", [path, "vm-profile.json"])): "", "{}"))
                                    )
                                )
                    })
}

output "base_path" {
    value = local.base_path
}

output "subdirectory_list" {
  value = local.subdirectory_list
}

output "subdirectory_map" {
  value = local.subdirectory_map
}
 
output "instances" {
  value = local.instances
}
