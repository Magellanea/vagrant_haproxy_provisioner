module VagrantPlugins
  module VagrantHaproxyProvisioner
    class ProvisionerConfig < Vagrant.plugin(2, :config)
      attr_accessor :app_name
      attr_accessor :balance
      attr_accessor :ips
      
      def initialize
        super
        @app_name = UNSET_VALUE
        @balance = UNSET_VALUE
        @ips = UNSET_VALUE
      end

      def finalize!
        @app_name = "appname" if @app_name == UNSET_VALUE
        @balance = "roundrobin" if @balance == UNSET_VALUE
        @ips = [] if @ips == UNSET_VALUE
      end

    end
  end
end
