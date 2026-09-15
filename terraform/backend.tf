terraform {
  backend "s3" {
    bucket       = "url-shortener-terraform-state-2026-harsa"
    key          = "url-shortener/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}