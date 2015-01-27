begin
  require "vagrant"
rescue LoadError
  raise "You need Vagrant to run Vagrant-ChaosMonkey"
end

module VagrantPlugins
  module VagrantHaproxyProvisioner
    class Plugin < Vagrant.plugin("2")
      name "Vagrant HaProxy Provisioner"
      description "HaProxy provisioner for vagrant"
      provisioner "haproxy_provisioner" do
        require_relative "provisioner.rb"
        Provisioner
      end

      config("haproxy_provisioner", :provisioner) do
        require_relative "provisioner_config.rb"
        ProvisionerConfig
      end

    end
  end
end
