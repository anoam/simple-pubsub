load 'thread_manager.rb'
class ListenersManager

  # TODO: реализовать механизм корретной отписки/отключения от сервера

  NoListenerError = Class.new(StandardError)
  PG_LISTENER_NAME = "postgres"
  REDIS_LISTENER_NAME = "redis"
  RABBIT_LISTENER_NAME = "rabbit"

  def initialize(config)

    @config = config.channel["env"]
    load_listener(config.root_path)

  end


  def listen(channel, &block)
    #треды лучше перенести в листенеры. раббит умеет сам тредиться
    #к тому же это даст возможность корректно отписываться и закрывать соединения
    ::ThreadManager.instance.add do
      listener.listen(channel, &block)
    end

  end

  private

  attr_reader :config

  def listener

    @listener ||=
      case listener_name
      when PG_LISTENER_NAME then Listeners::Postgres.new(config)
      when REDIS_LISTENER_NAME then Listeners::Redis.new(config)
      when RABBIT_LISTENER_NAME then Listeners::Rabbit.new(config)
      else fail(NoListenerError)
      end

  end

  def load_listener(root_dir)

    load File.join(root_dir, "listeners", "#{listener_name}.rb")

  end

  def listener_name
    config["type"]
  end

end
