# -*- mode: ruby -*-
# vi: set ft=ruby :
#^syntax detection

Vagrant::Config.run do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port 80, 8080
  
  config.vm.provision :chef_solo do |chef|
    chef.add_recipe 'build-essential'
    chef.add_recipe 'apt'
    chef.add_recipe 'django-native-deps'
    chef.add_recipe 'postgresql'
    
    chef.json = {
      "postgresql" => {
        "password" => {
          "postgres" => "md5eead77ff1bce6cff9efe1fa60380caf4"
        }
      }
    }  
  end

end