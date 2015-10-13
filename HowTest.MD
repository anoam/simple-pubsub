
```ruby
# Rabbit
require "bunny"
require "json"

connection = ::Bunny.new
connection.start

channel = connection.create_channel
exchange = channel.default_exchange
message = {type: :campaign, data: {id: 1, dirty_attributes: %i(name provider_status), data: {name: "Test campaign", provider_status: "PAUSED"}} }
exchange.publish(message.to_json, routing_key: :facebook_publish)

```
