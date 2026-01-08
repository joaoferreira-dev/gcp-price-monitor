resource "google_firestore_database" "database" {
  project     = var.project_id
  name        = "db_prices_monitor"
  location_id = var.region
  type        = "FIRESTORE_NATIVE"
}