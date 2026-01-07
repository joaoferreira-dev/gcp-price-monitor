terraform {
  backend "gcs" {
    bucket = "infra-gpm-terraform-state"
    prefix = "terraform/state"
  }
}

module "pubsub" {
  source     = "./modules/pubsub"
  project_id = var.project_id
}

module "database" {
  source     = "./modules/database"
  project_id = var.project_id
  region     = var.region
}

module "compute" {
  source     = "./modules/compute"
  project_id = var.project_id
  region     = var.region
  location   = var.location
}