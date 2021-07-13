require 'spec_helper'
require 'telemetry/amqp/base'
require 'telemetry/amqp/version'

RSpec.describe Telemetry::AMQP::Base do
  it 'should have app_version options' do
    expect(described_class.new.app_version).to be_a String
    expect(described_class.new.app_version).to eq Telemetry::AMQP::VERSION
    expect(described_class.new(app_version: 'foobar').app_version).to eq 'foobar'
  end

  it 'should have application options' do
    expect(described_class.new.application).to be_a String
    expect(described_class.new.application).to eq 'telemetry::amqp'
    expect(described_class.new(application: 'foobar_name').application).to eq 'foobar_name'
  end

  it 'should have a connection name' do
    expect(described_class.new.connection_name).to be_a String
    expect(described_class.new.connection_name).to eq "telemetry::amqp:#{Telemetry::AMQP::VERSION}"
    expect(described_class.new(connection_name: 'foobar_c_name').connection_name).to eq 'foobar_c_name'
  end
end
