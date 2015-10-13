#TODO: навести порядок с ключями (символы/ссылки/етц)
class Config < Struct.new(:root_path)

  CHANNEL_CONFIG_FILE = "config/channel.yml"
  DB_CONFIG_FILE = "config/db.yml"
  PROVIDER_CONFIG_FILE = "config/provider.yml"

  def channel

    @config ||= load_config(CHANNEL_CONFIG_FILE)

  end

  def data_base

    @db_config ||= load_config(DB_CONFIG_FILE)

  end

  def provider

    @provider_config ||= load_config(PROVIDER_CONFIG_FILE)

  end


  private

  def load_config(file_name)

    YAML.load_file(
      File.join(
        root_path,
        file_name
      )
    )

  end

end
