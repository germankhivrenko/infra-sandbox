packer {
    required_plugins {
        virtualbox = {
          version = "~> 1"
          source  = "github.com/hashicorp/virtualbox"
        }
        vagrant = {
          version = "~> 1"
          source = "github.com/hashicorp/vagrant"
        }
    }
}


source "virtualbox-ovf" "control-plane" {
  source_path = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.ova"

  guest_additions_path = "/tmp/VBoxGuestAdditions.iso"
  guest_additions_url = "/usr/share/virtualbox/VBoxGuestAdditions.iso"

  ssh_username = "packer"
  // ssh_password = "packer"
  ssh_private_key_file = "~/.ssh/id_rsa"

  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"

  // cd_files = ["user-data", "meta-data"]
  // cd_label = "cidata"

  vboxmanage = [
    // ["modifyvm", "{{.Name}}", "--cpus", "2"],
    // ["modifyvm", "{{.Name}}", "--memory", "1024"],  # 1 GB in MB
    // ["storagectl", "{{.Name}}", "--name", "IDE Controller", "--add", "ide", "--controller", "PIIX4"],
    ["storageattach", "{{.Name}}", "--storagectl", "IDE", "--port", "0", "--device", "0", "--type", "dvddrive", "--medium", "cloud-init/seed.iso"]
  ]

  pause_before_connecting = "10s"
}


build {
  sources = ["sources.virtualbox-ovf.control-plane"]

  provisioner "file" {
    source      = "scripts/install-vbox-guest-additions.sh"  # Path to the install-guest-additions script
    destination = "/tmp/install-vbox-guest-additions.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo /tmp/install-vbox-guest-additions.sh"
    ]
  }

  // provisioner "shell" {
  //   inline = [
  //     "sudo apt-get update",
  //     "sudo apt-get install -y build-essential dkms linux-headers-$(uname -r) mount",
  //     "sudo mkdir -p /mnt/vboxadd",
  //     "sudo mount -o loop /tmp/VBoxGuestAdditions.iso /mnt/vboxadd",
  //     "sudo /mnt/vboxadd/VBoxLinuxAdditions.run || true",
  //     "sudo umount /mnt/vboxadd",
  //     "sudo rm -rf /mnt/vboxadd",
  //     "sudo lsmod | grep vbox"
  //   ]
  // }

  provisioner "shell" {
    script = "scripts/install-containerd.sh"
    execute_command = "sudo {{ .Path }}"
  }

  post-processor "vagrant" {
    output = "output/control-plane.box"
  }
}

