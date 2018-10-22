variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable ssh_type {
  description = "Type of SSH"
}

variable ssh_user {
  description = "SSH user"
}

variable ssh_agent {
  description = "SSH agent"
}

variable private_key_ssh {
  description = "private key SSH"
}
