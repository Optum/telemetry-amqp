# Telemetry::AMQP
A ruby gem used to connect to RabbitMQ. 

## Examples
```ruby
require 'telemetry/amqp'

Telemetry::AMQP.connect!(username: 'guest', password: 'guest', node: '127.0.0.1')
Telemetry::AMQP.session # => Bunny::Session
Telemetry::AMQP.channel # => Bunny::Channel
```

You can also initiate multiple connections using the `Base` class
```ruby
rmq = Telemetry::AMQP::Base.new(username: 'guest', vhost: 'custom_vhost')
rmq.session # => Bunny:Session
rmq.channel # => Bunny::Channel
```

### Connection Options
These are the configurable options and their defaults
```ruby
{
  username: 'guest',
  password: 'guest',
  nodes: ['127.0.0.1'],
  port: 5672,
  use_ssl: false,
  connection_name: '',
  automatically_recover: true,
  verify_peer: true,
  application: 'telemetry::amqp',
  app_version: Telemetry::AMQP::VERSION,
  connection_name: 'telemetry_amqp:0.1.0'
}
```

### Channels
Currently channels within `Telemetry::AMQP` use the concurrent-ruby class of `Concurrent::ThreadLocalVar` so that we 
use a different channel for each Ruby thread automatically. This is per the [bunny docs](http://rubybunny.info/articles/concurrency.html)
> Parts of the library (most notably Bunny::Channel) are designed to assume they are not shared between threads.

