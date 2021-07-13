require 'spec_helper'
require 'telemetry/amqp'

RSpec.describe Telemetry::AMQP do
  it { should be_a Module }
  it 'should be able to connect' do
    expect { Telemetry::AMQP.connect!(vhost: '/') }.not_to raise_exception
    expect(Telemetry::AMQP.session).to be_a Bunny::Session
    expect(Telemetry::AMQP.channel).to be_a Bunny::Channel
  end

  it 'can create a channel' do
    expect(Telemetry::AMQP.create_channel).to be_a Bunny::Channel
    expect(Telemetry::AMQP.create_channel).not_to eq Telemetry::AMQP.channel
  end
end
