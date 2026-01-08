resource "google_pubsub_topic" "price_updates" {
  name = "topic-price-updates"
  project = var.project_id
}