resource "google_cloud_run_service" "default" {
  name     = "pgr-service"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/pgr301-exam-295320/app@sha256:3e4f8484e1817f87b23a70b5217f28dbd5ba349b5d0bc3d5e0215c31c6c01aca"
        env {
          name = "LOGZ_TOKEN"
          value = "var.logz_token"
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