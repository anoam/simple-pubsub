#TODO: Возможно, здесь не нужен класс, достаточно модуля
class MessageHandler
  class PublishHandler

    PUBLISH_CAMPAIGN_TYPE = "campaign"

    def initialize(message)

      @parsed_message = parse_message(message)

    end

    # Должно возвращать true или false чтобы делать ack для раббита
    def process

      handler.process

    # todo: Имеет смысл сделать полноценый тестер структуры сообщения
    rescue KeyError

      raise UnprocessableMessage

    end

    private

    attr_reader :parsed_message

    def parse_message(raw_message)

      JSON.parse(raw_message).symbolize_keys

    rescue TypeError, JSON::ParserError

      raise UnprocessableMessage

    end


    def handler

      case message_type
      when PUBLISH_CAMPAIGN_TYPE then CampaignHandler.new(parsed_message.fetch(:data))
      else fail UnprocessableMessage
      end

    end

    def message_type

      parsed_message.fetch(:type)

    end
  end
end
