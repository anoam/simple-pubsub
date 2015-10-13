class MessageHandler

  UnknownHandler = Class.new(StandardError)
  UnprocessableMessage = Class.new(StandardError)

  def initialize(publish_channel:)

    @publish_channel = publish_channel
    @handler_cache = {}

  end

  # Должно возвращать true или false чтобы делать ack для раббита
  def process(channel, message)

    handler(channel).new(message).process

  end

  private

  attr_accessor :handler_cache
  attr_reader :publish_channel

  def handler(channel)

    case channel
    when publish_channel then PublishHandler
    else
      fail UnknownHandler
    end

  end

end
