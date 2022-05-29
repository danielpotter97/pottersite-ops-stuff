# Ubuntu Server jammy
# ---
# Packer Template to create an Ubuntu Server (jammy) on Proxmox

# Variable Definitions
variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

# Resource Definiation for the VM Template
source "proxmox" "pottersite-template01" {
 
    # Proxmox Connection Settings
    proxmox_url = "${var.proxmox_api_url}"
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"
    # (Optional) Skip TLS Verification
    insecure_skip_tls_verify = true
    
    # VM General Settings
    node = "pve"
    vm_id = "101"
    vm_name = "pottersite-template01"
    template_description = "Ubuntu Server Template"

    # VM OS Settings
    # (Option 1) Local ISO File
    iso_file = "local:iso/ubuntu-22.04-live-server-amd64.iso"
    # - or -
    # (Option 2) Download ISO
    # iso_url = "https://releases.ubuntu.com/22.04/ubuntu-22.04-live-server-amd64.iso"
    # iso_checksum = "84aeaf7823c8c61baa0ae862d0a06b03409394800000b3235854a6b38eb4856f"
    iso_storage_pool = "local"
    unmount_iso = true

    # VM System Settings
    qemu_agent = true

    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"

    disks {
        disk_size = "20G"
        format = "qcow2"
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
        "e<wait>",
        "<down><down><down><end>",
        "<bs><bs><bs><bs><wait>",
        "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
        "<f10><wait>"
    ]
    boot = "c"

    boot_wait = "5s"

    # PACKER Autoinstall Settings
    http_directory = "/home/automations/provisioning/packer/ubuntu-server-22-04-docker/http/" 
    # (Optional) Bind IP Address and Port

    http_bind_address = "192.168.0.21"
    http_port_min = 8802
    http_port_max = 8802

    ssh_username = "potteradmin"

    # (Option 1) Add your Password here
    ssh_password = "ubuntu"
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
        source = "/home/automations/provisioning/packer/ubuntu-server-22-04-docker/files/99-pve.cfg"
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
            "sudo systemctl enable docker"
        ]
    }
    # Provisioning ansible
    provisioner "shell" {
        inline = [
            "sudo apt install software-properties-common -y",
            "sudo add-apt-repository --yes --update ppa:ansible/ansible",
            "sudo apt install ansible -y"
        ]
    }
     # Add SSH key to authorized key
    provisioner "shell" {
        inline = [
            "sudo echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1PLAFEKbjTZFsu/L+A/Stai93GT47gvrrI6TlhWKDroXQSIUtBMKlwTS/FRCHDxrSY/rNa1+/i5t1tnjxdzQa1nCGWlTJXeiGtYYfhSy+lU8KAqUJhCwyJfa+WGv4mNbx6QyohuEFoTVzyCbfvEnvTJhgwMF+VD9HGczVQHnF58syfzz6pjPuDJ6RE16O6SQCnSWv5SPEyxh/qjz/MzG6id8IHQPqkM1mV64ILVQ09vslK5e0mH85nEnOmaeJK6Vrd79/MfUvRgQVVcE2gzMhYQTUgESivqqVme55rDK1Y5wXyKEGekxJuiPPdnr12HYPEVJR9YCYIXqsjG4CNARtqdyZOOX7Bt/NzVDDE44SH3Vvfu7jEt48y6ekgPJoz+6HNWz8C4+lcKdU+LzDgQAamaxDQhf4P+JrDTUNGyBnizIo4+cREwDoSerMmaP56f9SMTctUVmC8QjzjXAYo+xBZ2CwprHLOV41O3HH6kj7fYYWOrBrnkulAjanxDRBFeM= potteradmin@jenkins01.pottersite.local > /home/potteradmin/.ssh/authorized_keys"
        ]
    }

    # Disable password authentication
    provisioner "shell" {
        inline = [
            "sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config",
            "echo 'DenyUsers ubuntu' | sudo tee -a /etc/ssh/sshd_config"
        ]
    }
}
