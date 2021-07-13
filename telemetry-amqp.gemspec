# frozen_string_literal: true

require_relative 'lib/telemetry/amqp/version'

Gem::Specification.new do |spec|
  spec.name          = 'telemetry-amqp'
  spec.version       = Telemetry::AMQP::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matt.iverson@optum.com']

  spec.summary       = 'Telemetry amqp Router'
  spec.description   = 'A gem to handle routing of InfluxDB queries based on measurement names'
  spec.homepage      = 'https://github.com/Optum/telemetry-amqp'
  spec.license       = 'Apache-2.0'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Optum/telemetry-amqp'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/Optum/telemetry-amqp/issues'
  spec.metadata['changelog_uri'] = 'https://github.com/Optum/telemetry-amqp/main/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'bunny'
  spec.add_dependency 'concurrent-ruby', '>= 1.1.7'
  spec.add_dependency 'concurrent-ruby-ext', '>= 1.1.7'
  spec.add_dependency 'connection_pool', '>= 2.2.3'
  spec.add_dependency 'dalli'
  spec.add_dependency 'faraday', '>= 1.3'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'multi_json'
  spec.add_dependency 'oj', '>= 3.11'

  spec.add_dependency 'telemetry-metrics-parser'
end
