require 'telemetry/amqp/version'
require 'telemetry/amqp/base'

module Telemetry
  module AMQP
    class << self
      def default
        @default ||= Telemetry::AMQP::Base.new
      end
    end
  end
end
