# Proxmox Provider
# ---
# Initial Provider Configuration for Proxmox

terraform {

    required_version = ">= 0.13.0"

    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "2.9.11"
        }
    }
}


variable "proxmox_api_token_secret" {
    type = string
}

provider "proxmox" {

    pm_api_url = "https://192.168.0.100:8006/api2/json"
    pm_api_token_id = "root@pam!jenkins"
    pm_api_token_secret = var.proxmox_api_token_secret
    pm_timeout = 1800

    pm_log_levels = {
     _default = "debug"
     _capturelog = ""
    }
    # (Optional) Skip TLS Verification
    pm_tls_insecure = true

}