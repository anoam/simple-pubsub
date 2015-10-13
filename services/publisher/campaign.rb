class Publisher

  class Campaign

    def initialize(api)

      @api = api.campaign

    end

    def publish

      campaigns_for_publish.find_each { |campaign| publish_single(campaign) }

    end


    private

    attr_reader :api


    def publish_single(campaign)
      #TODO: добавить флаг что взято в работу
      campaign.provider_id.present? ?  update(campaign) : create(campaign)
      #TODO: Обрабатывать ошибки из фб и присные
      #TODO: Возвращаем из работы
    end

    def update(campaign)

      api.update(campaign.provider_id, campaign.changed_to_hash)
      campaign.update_attributes(
        need_to_upload: false,
        dirty_attributes: []
      )
    end

    def create(campaign)

      response = api.create(campaign.changed_to_hash)

      campaign.update_attributes(
        provider_id: response["id"],
        need_to_upload: false,
        dirty_attributes: []
      )

    end

    def campaigns_for_publish
      # Здесь можно лимитировать. Я не стал
      ::Campaign.for_publish
    end


  end

end
