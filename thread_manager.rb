require 'singleton'

class ThreadManager
  include Singleton


  def add(&block)

    threads.push(new_thread(&block))

  end

  def shutdown

    threads.each(&:kill)

  end


  private

  def threads

    @threads ||= []

  end

  def new_thread(&block)

    # Todo: добавить обработку ошибок в тредах
    Thread.new(&block)

  end

end
