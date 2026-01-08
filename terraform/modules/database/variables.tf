variable "project_id" {
  description = "The project ID in GCP"
  type        = string
}

variable "region" {
  description = "Resource's region"
  type        = string
  default     = "us-east1"
}