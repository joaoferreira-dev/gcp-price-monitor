variable "project_id" {
  description = "The project ID in GCP"
  type        = string
}

variable "region" {
  description = "Resource's region"
  type        = string
  default     = "southamerica-east1"
}

variable "location" {
  description = "Resource's location"
  type        = string
  default     = "SOUTHAMERICA"
}