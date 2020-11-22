provider "google" {
  credentials = file("gkey.json")
  project     = "pgr301-exam-295320"
  region      = "us-central1"
  zone        = "us-central1-c"
}

resource "google_cloud_run_service" "default" {
  name     = "pgr-service"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/pgr301-exam-295320/app@sha256:27f42f4516ba0a247a95f3fc9d7d19a1c31d3a8eb5667a63ff7dee49646d00fe"
        env {
          name = "LOGZ_TOKEN"
          value = var.logz_token
        }
        env {
          name = "DB_USERNAME"
          value = var.db_username
        }
        env {
          name = "DB_PASSWORD"
          value = var.db_password
        }
        env {
          name = "auth0_issuer"
          value = format("https://%s/",var.auth0_domain)
        }
        env {
          name="auth0_audience"
          value = var.api_identifier
        }

      }
    }
  }
}


data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}