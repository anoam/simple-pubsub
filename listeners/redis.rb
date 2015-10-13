require 'redis'
require 'yaml'

module Listeners

  class Redis

    def initialize(config)

      @config = config
      init_client

    end

    def listen(channel, &block)

      client.subscribe(channel) do |on|

        on.message(&block)

      end

    end

    private

    attr_reader :client, :config

    def init_client

      @client = ::Redis.new(url: config["connection_string"])

    end

  end
end
