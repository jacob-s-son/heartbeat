module Heartbeat
  class TimeoutHandler
    attr_reader :alert_times, :counter

    def initialize(alert_times = [ 3, 10, 50, 100, 500 ].freeze)
      @alert_times = alert_times
      @counter     = 0
    end

    def trigger
      @counter += 1
      if alert_times.include?( counter )
        Logger.log( "Number of timeouts exceeded. Sending notification" )
      end
    end

    def reset
      @counter = 0
    end
  end
end