---
# Title of your post. If not set, filename will be used.
title: "Creating VM Template in Proxmox VE"
date: 2026-05-24T11:10:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - proxmox
---

This article is about creating `VM template` for easy creation of `VM` in [Proxmox VE](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview)  
Generally user creates the bare VM, and install the Operating system using ISO image.  
Here we have ubuntu base image, so we do not repeat installation procedure for each VM.

Here we use `Ubuntu 24.04 Cloud Image` as a starting point.

## Goal

Use `noble-server-cloudimg-amd64.img` to create a reusable Ubuntu 24.04 VM template in Proxmox without ISO installation.

This behaves similarly to AWS AMI + EC2 launch workflow.

---

## 0. Upload Cloud Image

Example:

```shell
scp noble-server-cloudimg-amd64.img root@proxmox:/var/lib/vz/template/iso/
# or simply upload to home folder of root user
scp noble-server-cloudimg-amd64.img root@proxmox:~/
```

You can place the image anywhere accessible on the Proxmox node.

---

## 1. Create Empty VM

Example VM ID: `9000`

```shell
# Here I create this script as 01-create-vm.sh
qm create 9000 \
  --name ubuntu-2404-template \
  --memory 4096 \
  --cores 2 \
  --net0 virtio,bridge=vmbr0
```

---

## 2. Import Disk Image

Assuming storage is `local-lvm`:

```shell
# Here I create this script as 02-cloud-image-import.sh
qm importdisk 9000 noble-server-cloudimg-amd64.img local-lvm
```

This imports the cloud image into Proxmox storage.

---

## 3. Attach Imported Disk

```shell
# Here I create this script as 03-attach-volume.sh
qm set 9000 --scsihw virtio-scsi-pci
qm set 9000 --scsi0 local-lvm:vm-9000-disk-0
```

---

## 4. Add Cloud-Init Drive

```shell
# Here I create this script as 04-cloud-init-disk.sh
qm set 9000 --ide2 local-lvm:cloudinit
```

Cloud-init is what makes this workflow similar to AWS AMI provisioning.

---

## 5. Configure Boot Order

```shell
# Here I create this script as 05-bootdisk.sh
qm set 9000 --boot c --bootdisk scsi0
```

---

## 6. Enable Serial Console

Recommended for Ubuntu cloud images:

```shell
# Here I create this script as 06-serial-console.sh
qm set 9000 --serial0 socket --vga serial0
```

---

## 7. Configure Cloud-Init Defaults

## SSH Key Authentication

```shell
# Here I create this script as 07-user.sh
qm set 9000 --ciuser ubuntu
#qm set 9000 --sshkey ~/.ssh/id_ed25519.pub
qm set 9000 --sshkey ~/.ssh/id_rsa.pub
qm set 9000 --ipconfig0 ip=dhcp
# optionally set password for default user `ubuntu`
# but, ubuntu base image is not allowing password authentication over ssh session.
# the password can be used on `console` instead
qm set 9000 --cipassword 'mypassword'
```

---

## 8. Convert VM to template

### (Recommended) Install qemu-guest-agent
(*I haven't tested yet, but suggested procedure*)

Start the VM once before converting to template.

Inside VM:

```shell
sudo apt update
sudo apt install qemu-guest-agent -y
sudo systemctl enable qemu-guest-agent
```

Then enable it in Proxmox:

```shell
qm set 9000 --agent enabled=1
```

Benefits:
- IP reporting
- Better shutdown/reboot handling
- Improved monitoring

### Convert VM to Template

```shell
# Here I create this script as 08-template.sh
qm template 9000
```

Now this works like a reusable AMI/golden image.

Once the VM9000 is set to be `template`, it can't be booted normal.  
If you want to add additional steps like installing required package,  
Either you clone the template and create new one as template,  
or, It can be reverted back to normal VM using following command.

```shell
qm set 9000 --template 0
```

**But, generally make `template` immutable is recommended.**

---

## 100. Clone New VM

Example:

```shell
# this is simplest general way
qm clone 9000 101 --name web-01
qm start 101
```

```shell
# Here I create this script as 100-web-01.sh
VMID=100
VM_IP=192.168.1.100
VM_NAME=web-01
VM_ROOT_SIZE=+32G
ROUTER=192.168.1.1

qm clone 9000 $VMID --name $VM_NAME
qm resize $VMID scsi0 $VM_ROOT_SIZE

MAC=$(qm config $VMID | \
  grep net0 | \
  sed -E 's/.*virtio=([^,]+).*/\1/')

# Here my mikrotik router provides DHCP address,
# So, I pass created mac address and wanted IP address.
ssh admin@$ROUTER \
"/ip dhcp-server lease add address=$VM_IP mac-address=$MAC comment=$VM_NAME"

qm start $VMID
```


New Ubuntu VM should boot in seconds.

---

## Example Infrastructure Layout

```text
9000 ubuntu-template
 ├─ 101 k8s-master
 ├─ 102 k8s-worker1
 ├─ 103 gitlab
```

---

## Useful Commands

### Resize Disk

```shell
qm resize 101 scsi0 +20G
```

### Open Console

```shell
qm terminal 101
```

### Show VM Config

```shell
qm config 101
```

### List VMs

```shell
qm list
```

---

## Notes

- Cloud images are preinstalled OS disk images.
- No ISO installation required.
- Closest equivalent to AWS AMI workflow in Proxmox.
- Best used with:
  - cloud-init
  - templates
  - cloning
  - Terraform automation

---

## Recommended Next Steps

- Terraform + Proxmox provider
- VLAN automation
- Kubernetes node templates
- GPU passthrough templates
- Full cloud-init customization
- CI/CD ephemeral VM workflows

---

> [!note]- This document is created with assist of ChatGPT
> Acutual command is tested on my server  
> 
> The overall step is provided by ChatGPT  
> (Since, I installed Proxmox VE first time, yesterday. I didn't look up for the official documentation at all)  
> (I first tried using Web UI, but the UI doesn't seem to provide create template.  
>  Since, I have years of experience using AWS and OpenStack)  
> 
> And `Notes`, `Recommended Next Steps` are add by ChatGPT
