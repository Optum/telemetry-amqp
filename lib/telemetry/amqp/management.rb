require 'telemetry/amqp/defaults'
require 'faraday'

module Telemetry
  module AMQP
    module Management
      include Telemetry::AMQP::Defaults

      def headers
        {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
      end

      def mgmt_user
        opts[:mgmt_user] || ENV["#{env_prefix}_mgmt_user"] || username
      end

      def mgmt_password
        opts[:mgmt_password] || ENV["#{env_prefix}_mgmt_password"] || password
      end

      def mgmt_node
        opts[:mgmt_node] || ENV["#{env_prefix})_mgmt_node"] || 'localhost'
      end

      def mgmt_port
        @mgmt_port ||= if opts.key? :mgmt_port
                         opts[:mgmt_port]
                       elsif ENV.key? "#{env_prefix}_mgmt_port"
                         ENV["#{env_prefix}_mgmt_port"].to_i
                       elsif use_ssl?
                         443
                       else
                         80
                       end
      end

      def mgmt_url(node = mgmt_node)
        "http#{'s' if use_ssl?}://#{node}:#{mgmt_port}"
      end

      def mgmt_connection(node = mgmt_node)
        @mgmt_connection ||= Faraday.new(mgmt_url(node), headers: headers) do |conn|
          conn.request :json
          conn.basic_auth(mgmt_user, mgmt_password)
          conn.response :json, parser_options: { symbolize_names: true }
        end
      rescue StandardError => e
        puts e.message
        nil
      end

      def ex_q_bindings(exchange:, queue:, vhost: '/', **)
        mgmt_connection.get("/api/bindings/#{vhost}/e/#{exchange}/q/#{queue}").body
      rescue StandardError => e
        puts e.message

        []
      end

      def remove_binding(exchange: 'influxdb.out', queue: "influxdb.#{hostname}", key: '#', vhost: '/', **)
        mgmt_connection.delete("/api/bindings/#{vhost}/e/#{exchange}/q/#{queue}/#{key}").success?
      rescue StandardError => e
        puts e.message

        false
      end
    end
  end
end
