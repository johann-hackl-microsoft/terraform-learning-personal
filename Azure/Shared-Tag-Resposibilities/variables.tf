variable "rg_name" {
  type    = string
  default = "rg-tag-tests"
}

variable "enforced_tags" {
  type = map(string)
  default = {
    "Environment" = "Production"
    "Owner"       = "Terraform"
  }
}