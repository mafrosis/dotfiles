# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "mafro/jessie64-gb-salt"
  config.vm.provider :vmware_fusion do |v|
    v.vmx['memsize'] = 1024
  end

  # salt config directory & shared dir in /tmp
  config.vm.synced_folder ".", "/srv/salt"
  config.vm.synced_folder "/tmp", "/tmp/host_machine"

  # setup the salt-minion
  config.vm.provision :salt do |salt|
    salt.minion_config = "salt-minion.conf"
    salt.run_highstate = false
  end
end
