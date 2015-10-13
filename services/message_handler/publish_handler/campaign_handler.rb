class MessageHandler

  class PublishHandler

    class CampaignHandler


      def initialize(data)
        @data = data.symbolize_keys
      end

      # Должно возвращать true или false чтобы делать ack для раббита
      def process
        #TODO: Если в работе - не пропускаем задачу - возвращаем в следующий раз
        campaign.merge(
          {
            need_to_upload: true,
            dirty_attributes: dirty_attributes,
            data: all_attributes,
          }
        )

        campaign.save!

      end

      private

      attr_reader :data

      def campaign

        @campaign ||=
          ::Campaign.find_by(external_id: external_id) || ::Campaign.new(external_id: external_id)

      end

      def external_id
        data.fetch(:id)
      end

      def dirty_attributes
        data.fetch(:dirty_attributes)
      end

      def all_attributes
        data.fetch(:data)
      end

    end

  end

end
