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

variable "names" {
  type = list(string)
  default = ["host"]
}

variable "cpu" {
  type = list(number)
  default = [1]
}

variable "ram" {
  type = list(number)
  default = [1]
}

# To simplify, make this identical for all hosts
variable "disk" {
  type = number
  default = 15
}

locals {
  n = ""
}

# Assumptions about the inputs:
# - No duplicate entries in "names"
# - All list variables have identical lengths
# No validation is done to check if the assumptions are correct.
resource "yandex_compute_instance" "terra" {

  for_each = toset(var.names)

  name = each.value
  hostname = each.value

  zone = "ru-central1-b"
  platform_id = "standard-v1"

  resources {
    cores  = var.cpu[index(var.names, each.value)]
    memory = var.ram[index(var.names, each.value)]
  }

  boot_disk {
    initialize_params {
      image_id = "fd8q5m87s3v0hmp06i5c"
      size = var.disk
      type = "network-ssd"
    }
  }

  network_interface {
    subnet_id = "e2lgv5mqm56n8fjkt37q"
    nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}
