require 'koala'
Koala.config.api_version = "v2.3"

module Facebook

  # Represents API for Facebook's Marketing API
  class Api

    # Facebook marketing entities
    FACEBOOK_OBJECTS = %w(campaign)

    # @!method graph
    #   @return [Koala::Facebook::API] instance of Koala api
    # @!method ad_account_id
    #   @return [String] ad account id in Facebook
    attr_reader :graph, :ad_account_id

    # @param token [String] access token for work with marketing api
    # @param provider_data [#[], Symbol] data for FB provider (Hash-like object)
    # @example required provider_data
    #  provider_data[:ad_account_id]
    #  provider_data[:app_secret]
    def initialize(token, provider_data)

      @graph =  Koala::Facebook::API.new(token, provider_data["app_secret"])

      @ad_account_id = provider_data["ad_account_id"]

    end

    # @!method campaign
    #   @return [Facebook::Campaign] contains Ad Campaign api methods
    FACEBOOK_OBJECTS.each do |fb_object|

      define_method(fb_object) do

        fb_obj = instance_variable_get("@#{fb_object}")

        return fb_obj if fb_obj

        instance_variable_set(
          "@#{fb_object}",
          "::Facebook::#{fb_object.camelize}".constantize.new(self)
        )

      end

    end

  end

end
