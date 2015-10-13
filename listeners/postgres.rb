require 'pg'
require 'sequel'
require 'yaml'
TCPSocket
module Listeners

  class Postgres

    def initialize(config)

      @config = config
      init_client

    end

    def listen(channel, &block)

      client.listen(channel, loop: true) do |channel, _pid, message|

        block.call(channel, message)

      end

    end

    private

    attr_reader :client, :config

    def init_client

      @client = ::Sequel.connect(config["connection_string"])

    end

  end
end
