terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.7.4"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.pm_api_url

  pm_user = var.pm_user

  pm_password = var.pm_password

  pm_tls_insecure = "true"
}

resource "proxmox_vm_qemu" "elk_vm" {
    desc        = "VM elk Server terraform"
    name        = "ELK-TEST" #"elk-vm"
    target_node = var.pm_node
    cores       = 2
    sockets     = 4
    onboot      = true
    numa        = true
    hotplug     = "network,disk,usb"
    clone       = "ubuntu-22-04-template"
    memory      = 32768
    balloon     = 2048
    scsihw      = "virtio-scsi-pci"
    bootdisk    = "scsi0"
  
    disk {
      size        = "250G"
      storage     = "local-lvm"
      type        = "scsi"
    }
  
    network {
      bridge    = "vmbr0"
      model     = "virtio"

    }
    provisioner "local-exec" {
      command = "echo '${proxmox_vm_qemu.elk_vm}' > vm_ip.txt"
  }
}