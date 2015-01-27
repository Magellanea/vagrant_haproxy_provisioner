module VagrantPlugins
  module VagrantHaproxyProvisioner
    class Provisioner < Vagrant.plugin("2", :provisioner)
      def provision
        commands = [install_haproxy, enable_haproxy, configure_haproxy(@config), start_haproxy]
        for command in commands
          @machine.communicate.sudo(command) do |t, data|
            @machine.env.ui.info(data.chomp, prefix: false)
          end
        end
      end

      def install_haproxy()
        'sudo apt-get -y install haproxy'
      end
      
      def enable_haproxy()
        'sudo sh -c "echo \'ENABLED=1\' > /etc/default/haproxy" '
      end
      
      def configure_haproxy(config)
        cfg_file = '/etc/haproxy/haproxy.cfg'
        com = 'sudo sh -c "echo \'%s\' > %s" \n'
        command = 'listen %s 0.0.0.0:80\n' % [config.app_name]
        command << '\tmode http\n'
        command << '\tstats enable\n'
        command << '\tstats uri /haproxy?stats\n'
        command << '\tbalance %s\n' % [config.balance]
        ips = config.ips
        for i in (1..ips.length)
          command << '\tserver s%s %s check\n' % [i.to_s, ips[i-1]]
        end
        com % [command, cfg_file]
      end

      def start_haproxy
        'sudo service haproxy restart'
      end

    end
  end
end
