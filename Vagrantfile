K8S_SERVER_API_IP="192.168.56.3"


Vagrant.configure("2") do |config|
  

  config.vm.define "control-plane" do |control_plane|
    control_plane.vm.box = "ubuntu/jammy64"
    control_plane.vm.hostname = "control-plane"

    control_plane.vm.network "private_network", ip: K8S_SERVER_API_IP

    control_plane.vm.provision "shell", inline: <<-SHELL
      sudo /vagrant/node-init/requirements.sh
      sudo /vagrant/node-init/control-plane.sh #{K8S_SERVER_API_IP}
    SHELL

    control_plane.vm.provider "virtualbox" do |vb|
      vb.name = "control-plane"
      vb.memory = 2048
      vb.cpus = 2
    end
  end

  (0..0).each do |i|
    config.vm.define "worker-#{i}" do |worker|
      worker.vm.box = "ubuntu/jammy64"
      worker.vm.hostname = "worker-#{i}"

      worker.vm.network "private_network", ip: "192.168.56.#{i + 4}"

      worker.vm.provision "shell", inline: <<-SHELL
        sudo /vagrant/node-init/requirements.sh
        sudo /vagrant/node-init/worker.sh
      SHELL

      worker.vm.provider "virtualbox" do |vb|
        vb.name = "worker-#{i}"
        vb.memory = 2048
        vb.cpus = 2
      end
    end
  end
end

