# Proxmox Full-Clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "pottersite-docker01" {
    
    #VM general settings
    target_node = "pve"
    vmid = "102"
    name = "pottersite-docker01"
    desc = "Swarm Cluster Manager Node"
    
    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "pottersite-template01"
    ipconfig0 = "ip=192.168.0.22/24,gw=192.168.0.1"
    nameserver = "192.168.0.1"

    # VM System Settings
    agent = 1

    # VM CPU Settings
    cores = 2
    sockets = 1
    cpu = "host"    
  
    # VM Memory Settings
    memory = 8192

    scsihw  = "virtio-scsi-pci"
    bootdisk = "virtio0"
    boot = "order=net0;virtio0;ide0;ide2"

    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"
    
 
     # (Optional) Default User
    ciuser = "potteradmin"
    ssh_user        = "potteradmin"
    ssh_private_key = <<EOF
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn
    NhAAAAAwEAAQAAAYEAtTywBRCm402RbLvy/gP0rWovdxk+O4L66yOk5YVig66F0EiFLQTC
    pcE0vxUQhw8a0mP6zWtfv4ubdbZ48Xc0GtZwhlpUyV3ohrWGH4UsvpVPCgKlCYQsMiX2vl
    hr+JjW8ekMqIbhBaE1c8gm37xJ70yYYMDBflQ/RxnM1UB5xefLMn88+qYz7gyekRNejukk
    Ap0lr+UjxMsYf6o8/zMxuonfCB0D6pDNZleuCC1UNPb7JSuXtJh/OZxJzpmniSula3e/fz
    H1L0YEFVXBNoMzIWEE1IBEor6qlZnueawytWOcF8ihBnpMSbojz3Z69dh2DxFSUfWAmCF6
    rIxuAjQEbancmTjl+wbfzc1QwxOOEh91b37u4xLePMunpIDyaM/uhzVs/AuPpXCnVPi8w4
    EAGpmsQ0IX+D/iaw01DRsgZ4syKOPnERMA6EnqzJmj+en/UjE3LVFZgvEI841wGKPsQWdg
    sKaxyzleNTtxx+pI+32GFjqwa55LpQI2p8Q0QRXjAAAFoAxreR8Ma3kfAAAAB3NzaC1yc2
    EAAAGBALU8sAUQpuNNkWy78v4D9K1qL3cZPjuC+usjpOWFYoOuhdBIhS0EwqXBNL8VEIcP
    GtJj+s1rX7+Lm3W2ePF3NBrWcIZaVMld6Ia1hh+FLL6VTwoCpQmELDIl9r5Ya/iY1vHpDK
    iG4QWhNXPIJt+8Se9MmGDAwX5UP0cZzNVAecXnyzJ/PPqmM+4MnpETXo7pJAKdJa/lI8TL
    GH+qPP8zMbqJ3wgdA+qQzWZXrggtVDT2+yUrl7SYfzmcSc6Zp4krpWt3v38x9S9GBBVVwT
    aDMyFhBNSARKK+qpWZ7nmsMrVjnBfIoQZ6TEm6I892evXYdg8RUlH1gJgheqyMbgI0BG2p
    3Jk45fsG383NUMMTjhIfdW9+7uMS3jzLp6SA8mjP7oc1bPwLj6Vwp1T4vMOBABqZrENCF/
    g/4msNNQ0bIGeLMijj5xETAOhJ6syZo/np/1IxNy1RWYLxCPONcBij7EFnYLCmscs5XjU7
    ccfqSPt9hhY6sGueS6UCNqfENEEV4wAAAAMBAAEAAAGAEQx9bmyLlnRUisr/Z7/Ng4aqom
    SAgy6mFfqLZ3/trX98XQSFap+5A8iyAouju2DDYClBjZNdNXKXlDIvHF/fSesEOM9EjJDF
    7+4hiNOJSwBWqBVpmwSQ98K0fGFq/r658ZW/uBbAEjyA/7xDU+atedJVvzxCt3SLY0/dAe
    6HxgMxDTYE8XszBWCwhesxiPYLiidoRSyj+b41NsU36bXSJr8TePrpxGYMvGThHSnOcxEM
    vQllwvpZdXzrQIEZzoCJbZRqI6hvsy9oM0lLf3g1oeRhLS/jY+krK1zyzA/r78aYPdvTMa
    kaJMj/06iif2uWWVcvc7JSeyzKHO61I9+mr7VFPweX+yZEx6ItHclDiDK8fnGrietRz0ko
    LipZIteuWazgWfVov6p/ZH2aDLgSQoASdWDnECAD70d7X0k6LbOMCi6qX6K4GZowgMUDUn
    4qUfZqjqEUsHx3fZcz7Kd56qNNzEb0FwQ8lA6vc84BAUxQMr07rfel4FU/PzhR9THRAAAA
    wGMcgmiMAR7WodhQ0MDPD7BHuPCKQTgOK/7DFcQxn+nRZ20YskxhGklpNdYxVpN5rmDfx+
    rQFZQw7+jdUFLhiZbVG7EI2YUcO+uHL8RRkki24soYycNwkptJuHOv+qdrmUiGQyhXPs7n
    edw8I5hCF3JwtfRvFYvDlg+pb3F8YysgfocTw2RbRy7IKS4BJvWdy40ET1tJRdv55QCe32
    Z9O7T9GvqMqdTqHQr2ZX7IDVA3HnWluh9ijwggawDZIgrbxQAAAMEA2fB/SUWe9IJ/b+/J
    sPn1Bs4PKNWGfzEBhxIHCRKKpZ1kntXBd/IR/VudchYWrJA1xPwJcGSbrooFquAPu6sck5
    LBIE0jYSXZBHZ0uzllR7xWEZC5M78KDaBXqBMewlO+zxr2J+ErC4NxS4xXbAxkQIBTrwZ/
    U/BSmP7ZYQkCQl3y3fw2glEBKVGgXzOhPqxtLIAjU7brtczqDvsciyvMYbpmTmWNCgp38b
    nctD4Pv2BdQt6ZwZEe5888g7q/U8rAAAAwQDU41KlBPzXrmhWxXuUf0W9eaBwM2sOZOE3
    t/EIGBlvzIcZG1uSLIya4vaezOOujrpqqGpa3n8dXJrDme2i5Pv5+6lO8jIwUBEMEkVhZ7
    7Xf3SG01gK+nqXG2OdJjnAchZ/tBAlG3TK9QPqvKQH2PmXUD5REoKMrhHSftzywzOTL+pi
    wKIi1Md3c8fqst6ANq9/+jj4oyLIu6U5Fk/nhQ54Wl4E4CsGrprXtWTQsvb9JA/ML6aACI
    Zk7Y+YPloaOCkAAAAmcG90dGVyYWRtaW5AamVua2luczAxLnBvdHRlcnNpdGUubG9jYWwB
    AgMEBQ==
    -----END OPENSSH PRIVATE KEY-----
    EOF
    # (Optional) Add your SSH KEY
    sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1PLAFEKbjTZFsu/L+A/Stai93GT47gvrrI6TlhWKDroXQSIUtBMKlwTS/FRCHDxrSY/rNa1+/i5t1tnjxdzQa1nCGWlTJXeiGtYYfhSy+lU8KAqUJhCwyJfa+WGv4mNbx6QyohuEFoTVzyCbfvEnvTJhgwMF+VD9HGczVQHnF58syfzz6pjPuDJ6RE16O6SQCnSWv5SPEyxh/qjz/MzG6id8IHQPqkM1mV64ILVQ09vslK5e0mH85nEnOmaeJK6Vrd79/MfUvRgQVVcE2gzMhYQTUgESivqqVme55rDK1Y5wXyKEGekxJuiPPdnr12HYPEVJR9YCYIXqsjG4CNARtqdyZOOX7Bt/NzVDDE44SH3Vvfu7jEt48y6ekgPJoz+6HNWz8C4+lcKdU+LzDgQAamaxDQhf4P+JrDTUNGyBnizIo4+cREwDoSerMmaP56f9SMTctUVmC8QjzjXAYo+xBZ2CwprHLOV41O3HH6kj7fYYWOrBrnkulAjanxDRBFeM= potteradmin@jenkins01.pottersite.local
    EOF

    provisioner "remote-exec" {
    inline = [
      "ip a"
    ]
  }

}
