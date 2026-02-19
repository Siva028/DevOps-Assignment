terraform {
  backend "gcs" {
    bucket = "pgagi-tf-state-siva123"
    prefix = "gcp/staging"
  }
}
