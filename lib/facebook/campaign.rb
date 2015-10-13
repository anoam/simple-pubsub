module Facebook

  # Represents AdCampaign in Facebook
  class Campaign

    # @!method graph
    #   @see Providers::Facebook::Api#graph
    # @!method ad_account_id
    #   @see Providers::Facebook::Api#ad_account_id
    delegate :graph, :ad_account_id, to: :api

    attr_accessor :presenter

    # @param api [Providers::Facebook::Api] instance of api that wraps koala's
    #   api
    def initialize(api)

      @api = api

    end

    # Creates ad campaign in Facebook
    # @param data [Hash] presenter that
    #   contains required data
    # @note "redownload => true" is not supported
    def create(data)

      graph.put_connections(
        ad_account_id,
        "adcampaign_groups",
        data_for_provider(data)
      )

    end

    # Updates ad campaign in Facebook
    # @param id [String] facebook id
    # @param data [Hash] presenter that
    #   contains required data
    def update(id, data)

      graph.put_connections(
        id,
        nil,
        data_for_provider(data)
      )

    end


    private

    attr_reader :api

    def data_for_provider(data)

      for_provider = {}
      for_provider[:name] = data["name"] if data["name"].present?
      #TODO: преобразование статусов
      for_provider[:campaign_group_status] = data["provider_status"]
      for_provider

    end

  end

end
