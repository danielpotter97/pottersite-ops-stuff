# Proxmox Full-Clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "pottersite-docker01" {
    
    #VM general settings
    target_node = "pve"
    vmid = "103"
    name = "pottersite-docker01"
    desc = "Swarm Cluster Manager Node"
    
    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "pottersite-dummy01"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 2
    sockets = 1
    cpu = "host"    
    
    # VM Memory Settings
    memory = 8192

    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # (Optional) IP Address and Gateway
    ipconfig0 = "ip=192.168.0.23/24,gw=192.168.0.1"
    nameserver = "192.168.0.1"
    # (Optional) Default User
    # ciuser = "your-username"
    
    # (Optional) Add your SSH KEY
    # sshkeys = <<EOF
    # #YOUR-PUBLIC-SSH-KEY
    # EOF
}
