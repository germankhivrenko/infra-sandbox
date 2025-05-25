Vagrant.configure("2") do |config|
#  cloud_init_iso_path = "cloud-init/cloud-init.iso"
#
#  (0..0).each do |i|
#    config.vm.define "control-plane-#{i}" do |node|
#      node.vm.box = "ubuntu/jammy64"
#      # node.vm.hostname = "control-plane-#{i}"
#
#      node.vm.network "private_network", ip: "192.168.56.#{i + 2}"
#
#      node.vm.provider "virtualbox" do |vb|
#        vb.name = "control-plane-#{i}"
#        vb.memory = 4096
#        vb.cpus = 2
#
#        # Mount the ISO as a CD-ROM
#        vb.customize ["storageattach", :id, "--storagectl", "IDE", "--port", "0", "--device", "0", "--type", "dvddrive", "--medium", cloud_init_iso_path]
#      end
#    end
#  end
#
#  
#  (0..0).each do |i|
#    config.vm.define "worker-#{i}" do |node|
#      node.vm.box = "ubuntu/jammy64"
#
#      node.vm.network "private_network", ip: "192.168.56.#{i + 10}"
#
#      node.vm.provider "virtualbox" do |vb|
#        vb.name = "worker-#{i}"
#        vb.memory = 2048
#        vb.cpus = 2
#
#        # Mount the ISO as a CD-ROM
#        vb.customize ["storageattach", :id, "--storagectl", "IDE", "--port", "0", "--device", "0", "--type", "dvddrive", "--medium", cloud_init_iso_path]
#      end
#    end
#  end

  (0..1).each do |i|
    config.vm.define "test-#{i}" do |node|
      node.vm.box = "ubuntu/jammy64"
      node.vm.hostname = "node-#{i}"

      node.vm.network "private_network", ip: "192.168.56.#{i + 2}"

      node.vm.provider "virtualbox" do |vb|
        vb.name = "test-#{i}"
        vb.memory = 2048
        vb.cpus = 2
      end
    end
  end
end

