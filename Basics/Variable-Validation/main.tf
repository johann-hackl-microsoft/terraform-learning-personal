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
