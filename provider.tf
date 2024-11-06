terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    time = {
      source = "hashicorp/time"
    }
  }
  required_version = ">= 0.13"
}


provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
  token     = var.yc_token
}
