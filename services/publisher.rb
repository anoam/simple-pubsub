class Publisher

  attr_reader :config

  def initialize(config)
    @config = config
  end

  def publish
    publish_campaigns
  end

  private

  def publish_campaigns
    campaign_publisher.publish
  end

  def api

    @api ||=
      ::Facebook::Api.new(
        config["token"],
        config.slice("ad_account_id", "app_secret")
      )

  end

  def campaign_publisher

    @campaign_publisher ||= Publisher::Campaign.new(api)

  end
end
