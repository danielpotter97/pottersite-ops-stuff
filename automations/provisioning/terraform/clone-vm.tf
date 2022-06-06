# Proxmox Full-Clone
# ---
# Create a new VM from a clone

variable "vmid" {
    type = string
}

variable "cores" {
    type = string
}

variable "memory" {
    type = string
}

variable "ip" {
    type = string
}

variable "vmname" {
    type = string
}

variable "desc" {
    type = string
}


resource "proxmox_vm_qemu" "pottersite-docker01" {
    
    #VM general settings
    target_node = "pve"
    vmid = var.vmid
    name = var.vmname
    desc = var.desc
    
    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "pottersite-template01"
   
    # VM System Settings
    agent = 1

    # VM CPU Settings
    cores = var.cores
    sockets = 1
    cpu = "host"    
  
    # VM Memory Settings
    memory = var.memory

    scsihw  = "virtio-scsi-pci"
    bootdisk = "virtio0"
    boot = "order=net0;virtio0;ide0;ide2"

    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"
    ipconfig0 = var.ip
    nameserver = "192.168.0.1"

 
     # (Optional) Default User
    ciuser = "potteradmin"
    
    # (Optional) Add your SSH KEY
    sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1PLAFEKbjTZFsu/L+A/Stai93GT47gvrrI6TlhWKDroXQSIUtBMKlwTS/FRCHDxrSY/rNa1+/i5t1tnjxdzQa1nCGWlTJXeiGtYYfhSy+lU8KAqUJhCwyJfa+WGv4mNbx6QyohuEFoTVzyCbfvEnvTJhgwMF+VD9HGczVQHnF58syfzz6pjPuDJ6RE16O6SQCnSWv5SPEyxh/qjz/MzG6id8IHQPqkM1mV64ILVQ09vslK5e0mH85nEnOmaeJK6Vrd79/MfUvRgQVVcE2gzMhYQTUgESivqqVme55rDK1Y5wXyKEGekxJuiPPdnr12HYPEVJR9YCYIXqsjG4CNARtqdyZOOX7Bt/NzVDDE44SH3Vvfu7jEt48y6ekgPJoz+6HNWz8C4+lcKdU+LzDgQAamaxDQhf4P+JrDTUNGyBnizIo4+cREwDoSerMmaP56f9SMTctUVmC8QjzjXAYo+xBZ2CwprHLOV41O3HH6kj7fYYWOrBrnkulAjanxDRBFeM= potteradmin@jenkins01.pottersite.local
    EOF


}
