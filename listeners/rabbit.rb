require 'bunny'
require 'yaml'

module Listeners

  class Rabbit

    def initialize(config)

      @config = config
      @logger = Logger.new(STDERR)
      init_client

    end

    def listen(queue_name, &block)

      init_queue(queue_name)

      # можно заюзать автоацк где нужно
      # TODO: сделать ацк/деклайн/etc конфигурабельным
      queue.subscribe(block: true, manual_ack: true) do |delivery_info, _metadata, payload|
        begin
          channel.acknowledge(delivery_info.delivery_tag) if block.call(delivery_info.routing_key, payload)
        rescue => error
          logger.error(error)
        end

      end
    end


    private

    attr_reader :connection, :client, :config, :channel, :queue, :logger

    def init_client

      @connection = ::Bunny.new(config["connection_string"])
      connection.start

    end

    def init_queue(queue_name)

      @channel = connection.create_channel
      @queue = channel.queue(queue_name)

    end

  end
end
