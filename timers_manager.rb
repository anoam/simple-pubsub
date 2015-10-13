require 'timers'

class TimersManager

  def initialize

    ThreadManager.instance.add { timers_loop }

  end

  def add(&block)
    fail ArgumentError unless block_given?

    yield timers

  end

  def clear

    timers.cancel

  end

  private

  def timers

    @timers ||= Timers::Group.new

  end

  def timers_loop
    loop { timers.wait }
  end

end
