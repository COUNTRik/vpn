# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
 
 #  config.vm.provision "ansible" do |ansible|
	# # ansible.verbose = "vvv"
	# ansible.playbook = "ansible/playbook/provision.yml"
	# ansible.become = "true"
 #  end

  config.vm.box = "centos/7"
  config.vm.define "server" do |server|
    server.vm.hostname = "server.loc"
    server.vm.network "private_network", ip: "192.168.10.10"
    server.vm.network "private_network", ip: "192.168.5.10"
    # server.vm.synced_folder "key/", "/Vagrant/key", SharedFoldersEnableSymlinksCreate: false
  end
  
  config.vm.define "client" do |client|
    client.vm.hostname = "client.loc"
    client.vm.network "private_network", ip: "192.168.10.20"
    client.vm.network "private_network", ip: "192.168.20.10"
  end

end