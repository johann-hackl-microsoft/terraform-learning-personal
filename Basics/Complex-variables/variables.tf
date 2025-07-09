variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "compute_environment" {
  description = "Compute environment and compute unit configuration with it's deployed app services"
  type = object({
    zone_redundant = optional(bool, false)
    compute_units_with_services = optional(list(object({
      compute_unit          = string
      compute_sku           = string
      compute_instances     = optional(number, null)
      blue_green_deployment = optional(bool, false)
      services = map(object({
        custom_domains = optional(list(string), [])
        cors = optional(object({
          allowed_origins     = list(string)
          support_credentials = optional(bool, false)
        }), null)
        auth = optional(object({
          client_id = string
          client_secret_setting_name = string
          name_claim_type            = string
          scopes                     = list(string)
        }))
      }))
      scale_out = optional(object({
        profiles = optional(list(
          object({
            name = string

            capacity = object({
              default = number
              maximum = number
              minimum = number
            })

            rules = optional(list(object({
              metric_trigger = object({
                metric_name        = string
                metric_resource_id = optional(string) # optional: default = current compute unit
                operator           = string
                statistic          = string
                time_aggregation   = string
                time_grain         = string
                time_window        = string
                threshold          = number
                metric_namespace   = optional(string)
                dimensions = optional(list(object({
                  name     = string
                  operator = string
                  values   = list(string)
                })), [])
                divide_by_instance_count = optional(bool, false)
              })
              scale_action = object({
                cooldown  = string
                direction = string
                type      = string
                value     = number
              })
            })), [])

            fixed_date = optional(object({
              end      = string
              start    = string
              timezone = optional(string, "UTC")
            }), null)

            recurrence = optional(object({
              timezone = optional(string, "UTC")
              days     = list(string)
              hours    = list(number)
              minutes  = list(number)
            }), null)
          })
        ), [])
      }), null)
      }
    )), [])
  })
  default = {
    zone_redundant              = false
    compute_units_with_services = []
  }
}