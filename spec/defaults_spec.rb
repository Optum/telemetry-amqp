require 'spec_helper'
require 'telemetry/amqp/defaults'

RSpec.describe Telemetry::AMQP::Defaults do
  it { should be_a Module }
  before :all do
    @class = Class.new do
      def initialize(**opts)
        @opts = opts
      end
      include Telemetry::AMQP::Defaults
    end
  end

  it 'should have a env_prefix' do
    expect(@class.new.env_prefix).to eq 'telemetry'
    expect(@class.new(env_prefix: 'telemetry').env_prefix).to eq 'telemetry'
    expect(@class.new(env_prefix: 'foobar').env_prefix).to eq 'foobar'
  end

  it 'should have a socket_hostname' do
    expect(@class.new.socket_hostname).to be_a String
  end

  it 'should have a hostname' do
    expect(@class.new.hostname).to eq @class.new.socket_hostname
    expect(@class.new(hostname: 'opt_host').hostname).to eq 'opt_host'
    ENV['telemetry_amqp_hostname'] = 'my_rspec_host'
    expect(@class.new.hostname).to eq 'my_rspec_host'
    ENV['telemetry_amqp_hostname'] = nil
  end

  it 'should have a username' do
    expect(@class.new.username).to eq 'guest'
    expect(@class.new(username: 'guest').username).to eq 'guest'
    expect(@class.new(username: 'foobar').username).to eq 'foobar'
    ENV['telemetry_amqp_username'] = 'env_foobar'
    expect(@class.new.username).to eq 'env_foobar'
    expect(@class.new(username: 'foobar').username).to eq 'foobar'
    ENV['telemetry_amqp_username'] = nil
  end

  it 'should have a password' do
    expect(@class.new.password).to eq 'guest'
    expect(@class.new(password: 'guest').password).to eq 'guest'
    expect(@class.new(password: 'foobar').password).to eq 'foobar'
    ENV['telemetry_amqp_password'] = 'env_foobar'
    expect(@class.new.password).to eq 'env_foobar'
    expect(@class.new(password: 'foobar').password).to eq 'foobar'
    ENV['telemetry_amqp_password'] = nil
  end

  it 'should have a vhost' do
    expect(@class.new.vhost).to eq 'telemetry'
    expect(@class.new(vhost: 'telemetry').vhost).to eq 'telemetry'
    expect(@class.new(vhost: 'foobar').vhost).to eq 'foobar'
    ENV['telemetry_amqp_vhost'] = 'env_foobar'
    expect(@class.new.vhost).to eq 'env_foobar'
  end

  it 'should have a use_ssl?' do
    expect(@class.new.use_ssl?).to eq false
    expect(@class.new(use_ssl: false).use_ssl?).to eq false
    expect(@class.new(use_ssl: true).use_ssl?).to eq true
    ENV['telemetry_amqp_use_ssl'] = 'true'
    expect(@class.new.use_ssl?).to eq true
    ENV['telemetry_amqp_use_ssl'] = 'foobar'
    expect(@class.new.use_ssl?).to eq false
    ENV['telemetry_amqp_use_ssl'] = '1'
    expect(@class.new.use_ssl?).to eq true
    ENV['telemetry_amqp_use_ssl'] = nil
  end

  it 'should have a port' do
    expect(@class.new.port).to eq 5672
    expect(@class.new(use_ssl: true).port).to eq 5671
    expect(@class.new(use_ssl: false).port).to eq 5672
    expect(@class.new(port: 8888).port).to eq 8888
    ENV['telemetry_amqp_port'] = '8899'
    expect(@class.new.port).to eq 8899
    ENV['telemetry_amqp_port'] = nil
  end

  it 'should have empty opts' do
    expect(@class.new.opts).to be_a Hash
  end
end
