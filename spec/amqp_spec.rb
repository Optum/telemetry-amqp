require 'spec_helper'
require 'telemetry/amqp'

RSpec.describe Telemetry::AMQP do
  it { should be_a Module }
  it 'should have a default value for default method' do
    expect(described_class.default).to be_a Telemetry::AMQP::Base
  end
end
