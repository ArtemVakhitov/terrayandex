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

variable "disk" {
  type = number
  default = 15
}

resource "yandex_compute_instance" "terra" {

  count = var.instances

  name = "terra-${count.index}"

  zone = "ru-central1-b"
  platform_id = "standard-v1"

  resources {
    cores  = var.cpu
    memory = var.ram
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
