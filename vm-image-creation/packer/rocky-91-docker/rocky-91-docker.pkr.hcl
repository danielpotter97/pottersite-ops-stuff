# Rocky Linux 9.1
# ---
# Packer Template to create a Rocky Linux 9.1 on Proxmox
packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

# Variable Definitions
variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

variable "ssh_passwd" {
    type = string
    sensitive = true
}

# Resource Definiation for the VM Template
source "proxmox" "rocky91-template01" {
 
    # Proxmox Connection Settings
    proxmox_url = "${var.proxmox_api_url}"
    username = "root@pam!jenkins"
    token = "${var.proxmox_api_token_secret}"
    # (Optional) Skip TLS Verification
    insecure_skip_tls_verify = true
    
    # VM General Settings
    node = "pve1"
    vm_id = "202"
    vm_name = "rocky91-template01"
    template_description = "Rocky Linux 9.1 Template"

    # VM OS Settings
    # (Option 1) Local ISO File
    iso_file = "local:iso/Rocky-9.1-x86_64-minimal.iso"
    # - or -
    # (Option 2) Download ISO
    # iso_url = "https://download.rockylinux.org/pub/rocky/9.1/isos/x86_64/Rocky-9.1-x86_64-dvd1.iso"
    # iso_checksum = "dce7e42e84b43f7d35d9b72b1c8f835dab802bbf"
    iso_storage_pool = "local"
    
    
   

    # VM System Settings
    qemu_agent = true

    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"

    disks {
        disk_size = "20G"
        format = "raw"
        storage_pool = "local-lvm"
        storage_pool_type = "lvm"
        type = "virtio"
    }

    # VM CPU Settings
    cores = "1"
    
    # VM Memory Settings
    memory = "2048" 

    # VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
    } 

    # VM Cloud-Init Settings
    cloud_init = true
    cloud_init_storage_pool = "local-lvm"
    
    
   # PACKER Boot Commands
   boot_command = [
        "<esc><wait>",
        "linux autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<wait>",
        "<enter><wait>"
    ]

    boot = "cdrom"
    boot_wait = "15s"
    

    # PACKER Autoinstall Settings
    http_directory = "vm-image-creation/packer/rocky-91-docker/http/" 
    # (Optional) Bind IP Address and Port

    http_bind_address = "192.168.0.107"
    http_port_min = 8803
    http_port_max = 8803

    ssh_username = "potteradmin"

    # (Option 1) Add your Password here
    ssh_password = "${var.ssh_passwd}"
    # - or -
    # (Option 2) Add your Private SSH KEY file here
    #ssh_private_key_file = "/home/potteradmin/.ssh/id_rsa"

    # Raise the timeout, when installation takes longer
    ssh_timeout = "20m"

    
  }
}