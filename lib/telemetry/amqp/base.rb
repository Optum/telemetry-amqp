require 'telemetry/amqp/defaults'
require 'telemetry/amqp/management'

require 'concurrent-ruby'
require 'bunny'

module Telemetry
  module AMQP
    class Base
      include Telemetry::AMQP::Defaults
      include Telemetry::AMQP::Management

      def initialize(auto_start: false, **opts)
        @opts = opts
        connect! if auto_start && !nodes.nil?
      end

      def session
        connect! if @session.nil? || !@session.respond_to?(:value)

        @session.value
      end

      def set_amqp_block_helpers
        session.on_blocked { puts 'Telemetry::AMQP is being blocked by RabbitMQ!' } if session.respond_to? :on_blocked

        if session.respond_to? :on_unblocked
          session.on_unblocked { puts 'Telemetry::AMQP is no longer being blocked by RabbitMQ' }
        end

        if session.respond_to? :after_recovery_completed # rubocop:disable Style/GuardClause
          session.after_recovery_completed { puts 'Telemetry::AMQP has completed recovery' }
        end
      end

      def connect!
        @session = Concurrent::AtomicReference.new(
          ::Bunny.new(
            hosts: nodes || ['localhost:5672'],
            username: username,
            password: password,
            vhost: vhost,
            port: port,
            connection_name: connection_name,
            log_level: ::Logger::WARN,
            logger: Telemetry::Logger,
            automatically_recover: opts[:automatically_recover] || true,
            verify_peer: opts[:verify_peer] || true,
            tls: use_ssl?
          )
        )
        @session.value.start
        @channel_thread = Concurrent::ThreadLocalVar.new(nil)
        set_amqp_block_helpers
        @session.value
      end

      def channel
        if !@channel_thread.nil? && !@channel_thread.value.nil? && @channel_thread.value.open?
          return @channel_thread.value
        end

        @channel_thread = Concurrent::ThreadLocalVar.new(nil) if @channel_thread.nil?
        @channel_thread.value = create_channel
      end

      def create_channel(consumer_pool_size: 1, abort_on_exception: false, timeout: 30)
        session.create_channel(nil, consumer_pool_size, abort_on_exception, timeout)
      end
    end
  end
end
