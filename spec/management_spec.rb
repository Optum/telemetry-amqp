require 'spec_helper'
require 'telemetry/amqp/management'

RSpec.describe Telemetry::AMQP::Management do
  it { should be_a Module }
  before :all do
    @class = Class.new do
      def initialize(**opts)
        @opts = opts
      end
      include Telemetry::AMQP::Management
    end
  end

  it 'should have headers' do
    expect(@class.new.headers).to be_a Hash
    expect(@class.new.headers['Content-Type']).to eq 'application/json'
    expect(@class.new.headers['Accept']).to eq 'application/json'
  end

  it 'should have a mgmt port' do
    expect(@class.new.mgmt_port).to eq 80
    expect(@class.new(use_ssl: false).mgmt_port).to eq 80
    expect(@class.new(use_ssl: true).mgmt_port).to eq 443
    expect(@class.new(use_ssl: true, mgmt_port: 15_672).mgmt_port).to eq 15_672
    ENV['telemetry_mgmt_port'] = '555'
    expect(@class.new.mgmt_port).to eq 555
    ENV['telemetry_mgmt_port'] = nil
  end

  it 'should have a mgmt_user' do
    expect(@class.new.mgmt_user).to eq 'guest'
    expect(@class.new(mgmt_user: 'testing').mgmt_user).to eq 'testing'
    expect(@class.new(username: 'username', mgmt_user: 'testing').mgmt_user).to eq 'testing'
    expect(@class.new(username: 'username').mgmt_user).to eq 'username'
    ENV['telemetry_mgmt_user'] = 'env_user'
    expect(@class.new.mgmt_user).to eq 'env_user'
    ENV['telemetry_mgmt_user'] = nil
  end

  it 'should have a mgmt_password' do
    expect(@class.new.mgmt_password).to eq 'guest'
    expect(@class.new(mgmt_password: 'testing').mgmt_password).to eq 'testing'
    expect(@class.new(password: 'password', mgmt_password: 'testing').mgmt_password).to eq 'testing'
    expect(@class.new(password: 'password').mgmt_password).to eq 'password'
    ENV['telemetry_mgmt_password'] = 'env_password'
    expect(@class.new.mgmt_password).to eq 'env_password'
    ENV['telemetry_mgmt_password'] = nil
  end

  it 'should have a mgmt_node' do
    expect(@class.new.mgmt_node).to eq 'localhost'
    expect(@class.new(mgmt_node: 'testing').mgmt_node).to eq 'testing'
  end

  it 'should have a mgmt_url' do
    expect(@class.new.mgmt_url('127.0.0.1')).to eq 'http://127.0.0.1:80'
    expect(@class.new.mgmt_url('localhost')).to eq 'http://localhost:80'
    expect(@class.new(use_ssl: false).mgmt_url('localhost')).to eq 'http://localhost:80'
    expect(@class.new(use_ssl: true, mgmt_port: 80).mgmt_url('localhost')).to eq 'https://localhost:80'
    expect(@class.new(use_ssl: true).mgmt_url('localhost')).to eq 'https://localhost:443'
  end

  it 'should have a mgmt_connection' do
    expect(@class.new.mgmt_connection).to be_a Faraday::Connection
    expect(@class.new.mgmt_connection({})).to eq nil
  end

  it 'should be able to get bindings' do
    # empty
  end

  it 'should be able to remove a binding' do
    # empty
  end
end
