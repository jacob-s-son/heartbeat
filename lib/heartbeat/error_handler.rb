module Heartbeat
  class ErrorHandler
    attr_reader :stack, :counter, :alert_times

    def initialize( alert_times = [ 3, 10, 50, 100, 500 ] )
      @alert_times  = alert_times
      reset
    end

    def register_error(error_hsh)
      @stack << error_hsh
      @counter += 1
      Notifier.notify(:error, error_hsh) if alert_times.include?( @counter )
    end

    def reset
      @stack    = []
      @counter  = 0
      Notifier.notify(:back_to_normal)
    end
  end
end