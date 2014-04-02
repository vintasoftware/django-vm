#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :
#^syntax detection

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "django-vm"
  config.vm.box = "debian7.4"
  config.vm.box_url = "https://vagrantcloud.com/ffuenf/debian-7.3.0-amd64/version/1/provider/vmware_desktop.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080
  
  config.vm.provision :chef_solo do |chef|
    chef.add_recipe 'apt'
    chef.add_recipe 'build-essential'
    chef.add_recipe 'git'
    chef.add_recipe 'python'
    chef.add_recipe 'postgresql::server'
    chef.add_recipe 'nginx'
    chef.add_recipe 'django-native-deps'
    chef.add_recipe 'default'
    
    chef.json = {
      postgresql: {
          enable_pgdg_apt: true,
          dir: "/etc/postgresql/9.2/main",
          config: {
              data_directory: "/var/lib/postgresql/9.2/main",
              hba_file: "/etc/postgresql/9.2/main/pg_hba.conf",
              ident_file: "/etc/postgresql/9.2/main/pg_ident.conf",
              external_pid_file: "/var/run/postgresql/9.2-main.pid",
              ssl_key_file: "/etc/ssl/private/ssl-cert-snakeoil.key",
              ssl_cert_file: "/etc/ssl/certs/ssl-cert-snakeoil.pem",
          },
          client: {
              packages: ["postgresql-client-9.2"],
          },
          server: {
              packages: ["postgresql-9.2", "postgresql-server-dev-9.2"],
          },
          contrib: {
              packages: ["postgresql-contrib-9.2"],
          },
          password: {
            postgres: 'postgres'
          },
          pg_hba: [
            {type: 'local', db: 'all', user: 'all', addr: nil, method: 'trust'},
            {type: 'host', db: 'all', user: 'all', addr: '127.0.0.1/32', method: 'trust'},
            {type: 'host', db: 'all', user: 'all', addr: '::1/128', method: 'trust'}
          ],
          version: "9.2"
      },
      app: {
        name: 'django-example'
      }
    }  
  end

end