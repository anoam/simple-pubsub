require "rubygems"
require 'yaml'

# TODO: к размышлению: может не стоит использовать АР, взял как самый привычный ОРМ
require "active_record"

load 'listeners_manager.rb'
load 'config.rb'
load 'timers_manager.rb'

class Application
  #TODO: к размышлению: возможно стоит переписать этот класс и использовать event machine
  def initialize

    @status = :stopped
    #TODO: зареюзать бы логгер
    @logger = Logger.new(STDERR)

  end

  def init_env

    init_db
    load_services
    load_libs

  end

  def run

    init_env

    start

    run_timers

    run_listeners

    eternal_loop

  end

  def shutdown

    timers_manager.clear

    ThreadManager.instance.shutdown

    stop

  end


  private

  attr_reader :logger
  attr_accessor :status

  def listeners_manager

    @listeners_manager ||= ListenersManager.new(config)

  end

  def timers_manager

    @timers_manager ||= TimersManager.new

  end

  def publisher

    @publisher ||= Publisher.new(config.provider)

  end
  #=============================================================================

  def run_listeners

    #TODO: работу с очередянми имеет смысл вынести в отдельную библиотеку чтобы реюзать
    listeners_manager.listen(config.channel["name"]) do |channel, message|

      message_handler.process(channel, message)

    end

  end

  def run_timers

    timers_manager.add do |timers|
      timers.now_and_every(60) { publisher.publish }
    end

  end

  #=============================================================================

  def config

    @config ||= Config.new(app_path)

  end

  def eternal_loop

    loop do
      break unless running?
      sleep(1)
    end

  end

  def stop

    self.status = :stopped

  end

  def start

    self.status = :running

  end

  def running?

    status == :running

  end

  def init_db

    ActiveRecord::Base.logger = logger
    ActiveRecord::Base.establish_connection(config.data_base["connection_string"])

    load_path(File.join("models", "*.rb"))

  end

  def load_libs

    load_path(File.join("lib", "**", "*.rb"))

  end

  def load_services

    load_path(File.join("services", "**", "*.rb"))

  end

  def load_path(path)

    Dir[File.join(app_path, path)].each { |file| load(file) }

  end

  def app_path

    File.dirname(File.expand_path(__FILE__))

  end

  def message_handler
    @message_handler ||= MessageHandler.new(publish_channel: config.channel["name"])
  end

end
