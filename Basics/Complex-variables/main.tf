data "azurerm_service_plan" "asp" {
  for_each = {
    for entry in var.compute_environment.compute_units_with_services :
    entry.compute_unit => entry
  }

  name                = each.value.compute_unit
  resource_group_name = var.resource_group_name
}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  # autoscale settings only for compute_units with scale_out config
  for_each = {
    for entry in var.compute_environment.compute_units_with_services :
    entry.compute_unit => entry
    if(
      entry.scale_out == null
      ? false
      : (entry.scale_out.profiles == null ? false : length(entry.scale_out.profiles) > 0)
    )
  }

  # assign to compute unit and use same name, resource group and location
  name                = each.value.compute_unit
  resource_group_name = var.resource_group_name
  location            = lookup(data.azurerm_service_plan.asp, each.value.compute_unit).location
  target_resource_id  = lookup(data.azurerm_service_plan.asp, each.value.compute_unit).id

  # multiple profile blocks, based on scale_out.profiles array
  dynamic "profile" {
    for_each = each.value.scale_out.profiles

    content {
      name = profile.value.name

      capacity {
        default = profile.value.capacity.default
        maximum = profile.value.capacity.maximum
        minimum = profile.value.capacity.minimum
      }

      # multiple rule blocks based on scale_out.profiles.rules array
      dynamic "rule" {
        for_each = profile.value.rules

        content {
          metric_trigger {
            metric_name = rule.value.metric_trigger.metric_name

            # metric_resource_id: if not specified or empty, use id of current compute_unit
            metric_resource_id = coalesce(rule.value.metric_trigger.metric_resource_id, lookup(data.azurerm_service_plan.asp, each.value.compute_unit).id)

            operator         = rule.value.metric_trigger.operator
            statistic        = rule.value.metric_trigger.statistic
            time_aggregation = rule.value.metric_trigger.time_aggregation
            time_grain       = rule.value.metric_trigger.time_grain
            time_window      = rule.value.metric_trigger.time_window
            threshold        = rule.value.metric_trigger.threshold
            metric_namespace = rule.value.metric_trigger.metric_namespace

            # multiple dimensions blocks based on scale_out.profiles.rules.metric_trigger.dimensions array
            dynamic "dimensions" {
              for_each = rule.value.metric_trigger.dimensions

              content {
                name     = dimensions.value.name
                operator = dimensions.value.operator
                values   = dimensions.value.values
              }
            }
          }

          scale_action {
            cooldown  = rule.value.scale_action.cooldown
            direction = rule.value.scale_action.direction
            type      = rule.value.scale_action.type
            value     = rule.value.scale_action.value
          }
        }
      }

      dynamic "fixed_date" {
        # scale_out.profiles.fixed_date is single element, therefore transform to array with one element to be usable for dynamic blob
        for_each = [
          for entry in [profile.value]: entry.fixed_date
          if entry.fixed_date != null
        ]
        content {
          end      = fixed_date.value.end
          start    = fixed_date.value.start
          timezone = fixed_date.value.timezone
        }
      }

      dynamic "recurrence" {
        # scale_out.profiles.recurrence is single element, therefore transform to array with one element to be usable for dynamic blob
        for_each = [
          for entry in [profile.value]: entry.recurrence
          if entry.recurrence != null
        ]

        content {
          timezone = recurrence.value.timezone
          days     = recurrence.value.days
          hours    = recurrence.value.hours
          minutes  = recurrence.value.minutes
        }
      }
    }
  }

  # not supported: predictive, notification
}