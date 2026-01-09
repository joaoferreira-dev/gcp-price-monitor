resource "google_firestore_database" "database" {
  project     = var.project_id
  name        = "db-prices-monitor"
  location_id = var.region
  type        = "FIRESTORE_NATIVE"
}