variable "env" {
  type        = string
  description = "Current environment, e.g. int, prod"

  validation {
    condition     = length(var.env) >= 3 && length(var.env) <= 4
    error_message = "Environment must be 3-4 characters long."
  }

  validation {
    condition     = can(regex("^[a-z]*$", var.env))
    error_message = "Environment must contain only lowercase letters."
  }
}

variable "location" {
  type        = string
  description = "define the cloud location which tf should use."

  validation {
    condition     = length(var.location) >= 3 && length(var.location) <= 4
    error_message = "Location must be 3-4 characters long."
  }

  validation {
    condition     = can(regex("^[a-z0-9]*$", var.location))
    error_message = "Location must contain only lowercase letters and digits."
  }
}

variable "instance_name" {
  type        = string
  description = "Name of the codebeamer instance."

  validation {
    condition     = var.instance_name != "setup"
    error_message = "To prevent confusion with the actual setup vm, deployed once per environment, 'setup' is not allowed as instance name."
  }

  validation {
    condition     = length(var.instance_name) >= 3 && length(var.instance_name) <= 9
    error_message = "Instance name must be 3-9 characters long."
  }

  validation {
    condition     = can(regex("^[a-z0-9]{3,9}$", var.instance_name))
    error_message = "Instance name must be lowercase, 3-9 chars long and only containing a-z + 0-9."
  }
}