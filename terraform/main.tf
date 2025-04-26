terraform {
  required_providers {
    virtualbox = {
      source = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}


# There are currently no configuration options for the provider itself.


resource "virtualbox_vm" "k8s-control-plane" {
  count     = 1
  name      = format("k8s-control-plane-%02d", count.index + 1)
  image     = "../packer/output/packer-k8s-control-plane.box"
  cpus      = 2
  memory    = "1024 mib"
  # user_data = file("${path.module}/user_data")

  network_adapter {
    type           = "hostonly"
    host_interface = "vboxnet0"
  }
}

output "node_ips" {
  value = [for vm in virtualbox_vm.k8s-control-plane : vm.network_adapter.0.ipv4_address]
}

