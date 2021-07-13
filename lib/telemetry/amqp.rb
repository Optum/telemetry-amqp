require 'telemetry/amqp/version'
require 'telemetry/amqp/base'

module Telemetry
  module AMQP
    class << self
      def connect!(**opts)
        @connection = Telemetry::AMQP::Base.new(**opts)
        @connection.connect!

        @connection
      end

      def connection
        return @connection unless @connection.nil?

        nil
      end

      def session
        @connection&.session
      end

      def channel
        return nil if session.nil?

        session.channel
      end

      def create_channel(consumer_pool_size: 1, abort_on_exception: false, timeout: 30)
        session.create_channel(nil, consumer_pool_size, abort_on_exception, timeout)
      end
    end
  end
end
