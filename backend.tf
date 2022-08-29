terraform {
  backend "s3" {
    bucket = "grupotfstate"
    key    = "open-vpn"
    region = "us-east-1"
  }
}