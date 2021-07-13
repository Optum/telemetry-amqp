require 'spec_helper'
require 'telemetry/amqp'

RSpec.describe Telemetry::AMQP::Base do
  it 'should be able to establish a session' do
    expect { described_class.new(vhost: '/').connect! }.not_to raise_exception
  end

  it 'should manage channels' do
    @session = described_class.new(vhost: '/')
    @session.connect!

    expect(@session.channel).to be_a Bunny::Channel
    expect(@session.create_channel).to be_a Bunny::Channel
    @new_channel = @session.create_channel
    expect(@new_channel).to be_a Bunny::Channel
    expect(@session.channel).not_to eq @new_channel
  end
end
