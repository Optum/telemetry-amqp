module Telemetry
  module AMQP
    module Defaults
      def socket_hostname
        Socket.gethostname.delete_suffix('.').downcase
      end

      def env_prefix
        @opts[:env_prefix] || 'telemetry'
      end

      def hostname
        @hostname ||= if opts.key? :hostname
                        opts[:hostname]
                      elsif ENV.key? "#{env_prefix}_amqp_hostname"
                        ENV["#{env_prefix}_amqp_hostname"]
                      else
                        socket_hostname
                      end
      end

      def username
        @username ||= if opts.key? :username
                        opts[:username]
                      elsif ENV.key? "#{env_prefix}_amqp_username"
                        ENV["#{env_prefix}_amqp_username"]
                      else
                        'guest'
                      end
      end

      def password
        @password ||= if opts.key? :password
                        opts[:password]
                      elsif ENV.key? "#{env_prefix}_amqp_password"
                        ENV["#{env_prefix}_amqp_password"]
                      else
                        'guest'
                      end
      end

      def vhost
        @vhost ||= if opts.key? :vhost
                     opts[:vhost]
                   elsif ENV.key? "#{env_prefix}_amqp_vhost"
                     ENV["#{env_prefix}_amqp_vhost"]
                   else
                     'telemetry'
                   end
      end

      def use_ssl?
        @use_ssl unless @use_ssl.nil?

        @use_ssl = if opts.key? :use_ssl
                     opts[:use_ssl]
                   elsif ENV.key? "#{env_prefix}_amqp_use_ssl"
                     ENV["#{env_prefix}_amqp_use_ssl"] == 'true' || ENV["#{env_prefix}_amqp_use_ssl"] == '1'
                   else
                     false
                   end
      end

      def port
        @port ||= if opts.key? :port
                    opts[:port]
                  elsif ENV.key? "#{env_prefix}_amqp_port"
                    ENV["#{env_prefix}_amqp_port"].to_i
                  elsif use_ssl?
                    5671
                  else
                    5672
                  end
      end

      def application
        opts.key?(:application) ? @opts[:application] : 'telemetry::amqp'
      end

      def app_version
        opts.key?(:app_version) ? @opts[:app_version] : Telemetry::AMQP::VERSION
      end

      def connection_name
        opts[:connection_name] || "#{application || 'telemetry_amqp'}:#{app_version || Telemetry::AMQP::VERSION}"
      end

      def nodes
        opts[:nodes]
      end

      def opts
        @opts ||= {}
      end
    end
  end
end
