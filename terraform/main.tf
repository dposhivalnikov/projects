provider "google" {
  project = "${var.project}"
  region = "${var.region}"
}

resource "google_compute_instance" "app" {
  name         = "nginx-app"
  machine_type = "g1-small"
  zone         = "europe-west1-b"

  connection {
    type        = "${var.ssh_type}"
    user        = "${var.ssh_user}"
    agent       = "${var.ssh_agent}"
    private_key = "${file(var.private_key_ssh)}"
 }

  provisioner "nginx-install" {
    script = "files/install.sh"
  }
  tags = ["nginx-app"]
  metadata {
  sshKeys = "appuser:${file(var.public_key_path)}"
  }
  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }
  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"
    access_config = {
    nat_ip = "${google_compute_address.app_ip.address}"
}
    # использовать ephemeral IP для доступа из Интернет
    #access_config {}
  }
}

resource "google_compute_firewall" "firewall_nginx" {
  name = "allow-nginx-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с тегом ...
  target_tags = ["nginx-app"]
}

resource "google_compute_firewall" "firewall_ssh" {
  name = "default-allow-ssh"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "app_ip" {
name = "nginx-app-ip"
}

