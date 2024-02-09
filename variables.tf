##
# Variables
##

variable "location" {
  type    = string
  default = "northeurope"
}

variable "resource_group_name" {
  type    = string
  default = "rg-techielass-dns"
}

variable "tag_environment" {
  type    = string
  default = "environment"
}

variable "tag_environment_name" {
  type    = string
  default = "production"
}

variable "ttl" {
  description = "Time to live in seconds"
  type        = number
  default     = 300
}


variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}