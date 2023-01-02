# Ubuntu Server jammy
# ---
# Packer Template to create an Ubuntu Server (jammy) on Proxmox
packer {
  required_plugins {
    proxmox = {
      version = " >= 1.1.0"
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
source "proxmox" "pottersite-template01" {
 
    # Proxmox Connection Settings
    proxmox_url = "${var.proxmox_api_url}"
    username = "root@pam!jenkins"
    token = "${var.proxmox_api_token_secret}"
    # (Optional) Skip TLS Verification
    insecure_skip_tls_verify = true
    
    # VM General Settings
    node = "pve1"
    vm_id = "200"
    vm_name = "pottersite-template01"
    template_description = "Ubuntu Server Template"

    # VM OS Settings
    # (Option 1) Local ISO File
    iso_file = "local:iso/ubuntu-22.04.1-live-server-amd64.iso"
    # - or -
    # (Option 2) Download ISO
    # iso_url = "https://releases.ubuntu.com/22.04/ubuntu-22.04-live-server-amd64.iso"
    # iso_checksum = "84aeaf7823c8c61baa0ae862d0a06b03409394800000b3235854a6b38eb4856f"
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
    boot      = "c"
    boot_wait = "5s"
    boot_command = [
     "<esc><wait>",
     "e<wait>",
     "<down><down><down><end>",
     "<bs><bs><bs><bs><wait>",
     "autoinstall ds=nocloud-net;s=/cidata/ ---<wait>",
     "<f10><wait>"
    ]


    unmount_iso = true
    

    # PACKER Autoinstall Settings
    http_directory = "vm-image-creation/packer/ubuntu-22-docker/http/" 
    # (Optional) Bind IP Address and Port

    http_bind_address = "192.168.0.107"
    http_port_min = 8802
    http_port_max = 8802

    ssh_username = "potteradmin"

    # (Option 1) Add your Password here
    ssh_password = "${var.ssh_passwd}"
    # - or -
    # (Option 2) Add your Private SSH KEY file here
    #ssh_private_key_file = "/home/potteradmin/.ssh/id_rsa"

    # Raise the timeout, when installation takes longer
    ssh_timeout = "20m"
}   

# Build Definition to create the VM Template
build {

    name = "pottersite-template01"
    sources = ["source.proxmox.pottersite-template01"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo sync"
        ]
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "vm-image-creation/packer/ubuntu-22-docker/files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }

    # Provisioning the VM Template with Docker Installation #4
    provisioner "shell" {
        inline = [
            "sudo apt-get install -y ca-certificates curl gnupg lsb-release",
            "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
            "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
            "sudo apt-get -y update",
            "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
            "sudo apt-get install -y docker-compose",
            "sudo usermod -aG docker potteradmin",
            "sudo systemctl enable docker"
        ]
    }
    # Provisioning ansible
    provisioner "shell" {
        inline = [
            "sudo apt install software-properties-common -y",
            "sudo add-apt-repository --yes --update ppa:ansible/ansible",
            "sudo apt install ansible unzip -y"
        ]
    }
  
}
