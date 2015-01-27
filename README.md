# VagrantHaproxyProvisioner

This is a dummy HAProxy provisioner for Vagrant,
all what it does is that you pass it a set of ips and a balance type and other configurations and it will setup HAProxy on that node and handle those configurations

## Usage

```
# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'json'

Vagrant.configure(2) do |config|
  # If the file doesn't exist, make ips automatics
  ips = File.exist?("ips.json") ? JSON.parse(open("ips.json").readline()) : nil
  n = ips.nil? ? 1 : ips.length
  config.vm.box = "precise64"
  (1..n).each do |n|
    config.vm.define ("loadbalancer_node%d" % n) do |machine|
      options = {}
      unless ips.nil?
        options[:ip] =  ips[n-1]
      end
      machine.vm.network :public_network , options
      # change that to use chef/puppet
      machine.vm.provision "shell", path: "install_apache2.sh"
    end
  end
  config.vm.define("loadbalancer") do |machine|
    machine.vm.network :public_network
    machine.vm.provision "haproxy_provisioner" do |p|
      p.ips = ips.nil? ? [] : ips
    end

  end
end
```

The above script gets a list of ips (free) from ```ips.json``` file and then it create a node for each, it use a simple script to install LAMP on each node, for the ```loadbalancer``` node the configurations are clear.

## Notes

This is intended only for testing purposes.

