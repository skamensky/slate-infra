variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "alert_emails" {
  description = "List of email addresses to receive billing alerts"
  type        = list(string)
  validation {
    condition     = length(var.alert_emails) > 0
    error_message = "At least one email address must be provided for billing alerts."
  }
}

variable "total_billing_threshold" {
  description = "Total billing threshold in USD"
  type        = number
  default     = 100
}

variable "billing_thresholds" {
  description = "Map of billing thresholds by category"
  type        = map(number)
  default = {
    warning  = 50
    critical = 80
  }
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
} 