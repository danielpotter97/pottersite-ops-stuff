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


resource "proxmox_vm_qemu" "proxmox_vm"  {
    
    #VM general settings
    target_node = "pve1"
    vmid = var.vmid
    name = "${var.vmname}"
    desc = var.desc
    
    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "rocky87-template01"

    os_type = "cloud-init"

   
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


    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    disk {
        size            = "50G"
        type            = "scsi"
        storage         = "local-lvm"
    }
    # VM Cloud-Init Settings

    lifecycle {
        ignore_changes = [
             network,
        ]
    }
    ipconfig0 = var.ip
    nameserver = "192.168.0.1"

}
