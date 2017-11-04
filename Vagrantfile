# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "mafrosis/jessie64-gb-salt"
  config.vm.provider :vmware_fusion do |v|
    v.vmx['memsize'] = 512
    v.vmx['numvcpus'] = 1
  end

  config.vm.network "public_network"

  # create a shared dir in /tmp
  config.vm.synced_folder "/tmp", "/tmp/host_machine"

  # setup the salt-minion
  config.vm.provision :salt do |salt|
    salt.minion_config = "salt-minion.conf"
    salt.run_highstate = false
    salt.bootstrap_options = '-D -F -c /tmp'
  end
end
