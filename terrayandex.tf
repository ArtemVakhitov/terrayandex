terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-b"
}

variable "cpu" {
  type = number
  default = 1
}

variable "ram" {
  type = number
  default = 1
}

variable "instances" {
  type = number
  default = 1
}
