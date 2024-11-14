VMID=8100
STORAGE=local-lvm

wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
qemu-img resize noble-server-cloudimg-amd64.img 25G
qm create $VMID --memory 2048 --core 2 --name ubuntu-cloud-noble --net0 virtio,bridge=vmbr0 --cpu host --agent 1 --vga serial0 --serial0 socket
qm disk import $VMID noble-server-cloudimg-amd64.img $STORAGE
qm set $VMID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-$VMID-disk-0
qm set $VMID --ide2 $STORAGE:cloudinit
qm set $VMID --boot c --bootdisk scsi0
qm set $VMID --ciuser tmpadmin --cipassword 'Abc13794682'
qm set $VMID --ipconfig0 ip=dhcp
qm set $VMID --cicustom "vendor=local:snippets/ubuntu.yaml"
qm set $VMID --tags ubuntu-template,noble,cloudinit
qm set $VMID --sshkeys ~/id_ed25519.pub
qm template $VMID