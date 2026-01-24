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
  name   = "source-${data.archive_file.function_zip.output_md5}.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.function_zip.output_path
}

resource "google_cloudfunctions_function" "function" {
  name        = "gcp-price-monitor"
  runtime     = "python312"
  region      = var.region
  project     = var.project_id

  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "handler" # Nome da função no seu main.py
}

resource "google_service_account" "scheduler_sa" {
  account_id   = "gcp-price-monitor-scheduler"
  display_name = "gcp-price-monitor"
  project      = var.project_id
}

resource "google_cloud_scheduler_job" "job" {
  name     = "daily-price-check"
  schedule = "0 9 * * *"
  project  = var.project_id
  region   = var.region

  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.function.https_trigger_url

    body = base64encode(jsonencode({
      url = "https://br.tradingview.com/symbols/BTCUSD/"
    }))

    headers = {
      "Content-Type" = "application/json"
    }

    oidc_token {
      service_account_email = google_service_account.scheduler_sa.email
    }
  }
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = var.project_id
  region         = var.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_service_account.scheduler_sa.email}"
}