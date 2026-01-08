data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.root}/../src"
  output_path = "${path.root}/function-source.zip"
}

resource "google_storage_bucket" "bucket" {
  name     = "${var.project_id}-gcf-source"
  location = var.location
  project  = var.project_id
}

resource "google_storage_bucket_object" "archive" {
  name   = "source.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.function_zip.output_path
}

resource "google_cloudfunctions_function" "function" {
  name        = "gcp-price-monitor"
  runtime     = "python312"
  region      = var.region
  project     = var.project_id

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "handler" # Nome da função no seu main.py
}

resource "google_cloud_scheduler_job" "job" {
  name     = "daily-price-check"
  schedule = "0 9 * * *"
  project  = var.project_id
  region   = var.region

  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions_function.function.https_trigger_url
  }
}