variable "description" {
  type        = string
  description = "A brief description for the resource or module."
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to the resources for identification and organization."
}

variable "ou_ids" {
  type        = list(string)
  default     = null
  description = "A list of organizational unit (OU) IDs to target."
}

variable "policy_statement" {
  type        = string
  description = "The JSON-encoded IAM policy statement to be applied."
}

variable "policy_name" {
  type        = string
  description = "The name of the IAM policy being created."
}
